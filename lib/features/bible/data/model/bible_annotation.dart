import 'package:flutter/material.dart';

enum BibleAnnotationType { highlight, note, bookmark }

/// The highlight colors (names as the backend stores them).
enum HighlightColor {
  yellow(Color(0xFFFFE066)),
  green(Color(0xFF8CE99A)),
  blue(Color(0xFF74C0FC)),
  pink(Color(0xFFFAA2C1)),
  purple(Color(0xFFB197FC));

  const HighlightColor(this.color);

  final Color color;

  static HighlightColor? byName(String? name) => values.where((c) => c.name == name).firstOrNull;
}

/// A highlight, note or bookmark (`/bible/annotations`). [id] is made by the app (UUID), so a change made offline can
/// be sent later. [numbering] is the chapter's verse numbering label in [translation] where it was made: it is shown
/// in the translations whose chapter has the same label.
class BibleAnnotation {
  const BibleAnnotation({
    required this.id,
    required this.type,
    required this.translation,
    required this.numbering,
    required this.book,
    required this.chapter,
    required this.verseStart,
    required this.verseEnd,
    this.color,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.deleted = false,
  });

  final String id;
  final BibleAnnotationType type;
  final String translation;
  final String numbering;

  /// OSIS code
  final String book;
  final int chapter;
  final int verseStart;
  final int verseEnd;
  final HighlightColor? color;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool deleted;

  bool covers(int verse) => verse >= verseStart && verse <= verseEnd;

  factory BibleAnnotation.fromJson(Map<String, dynamic> json) => BibleAnnotation(
    id: json['id'] as String,
    type: BibleAnnotationType.values.firstWhere(
      (t) => t.name.toUpperCase() == json['type'],
      orElse: () => BibleAnnotationType.bookmark,
    ),
    translation: json['translation'] as String? ?? '',
    numbering: json['numbering'] as String? ?? 'kjv',
    book: json['book'] as String,
    chapter: (json['chapter'] as num).toInt(),
    verseStart: (json['verseStart'] as num).toInt(),
    verseEnd: (json['verseEnd'] as num).toInt(),
    color: HighlightColor.byName(json['color'] as String?),
    note: json['note'] as String?,
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    deleted: json['deleted'] == true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name.toUpperCase(),
    'translation': translation,
    'numbering': numbering,
    'book': book,
    'chapter': chapter,
    'verseStart': verseStart,
    'verseEnd': verseEnd,
    'color': color?.name,
    'note': note,
    'createdAt': createdAt?.toUtc().toIso8601String(),
    'updatedAt': updatedAt?.toUtc().toIso8601String(),
    'deleted': deleted,
  };

  BibleAnnotation copyWith({HighlightColor? color, String? note, DateTime? updatedAt}) => BibleAnnotation(
    id: id,
    type: type,
    translation: translation,
    numbering: numbering,
    book: book,
    chapter: chapter,
    verseStart: verseStart,
    verseEnd: verseEnd,
    color: color ?? this.color,
    note: note ?? this.note,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted,
  );
}

/// Where verse [verse] of a chapter numbered [from] is in the same chapter numbered [to] (labels from the backend's
/// build: "kjv", "heb", "kar", ...). Psalms with a title follow a fixed rule: "heb" counts the title as verse 1, "kjv"
/// puts it into verse 1, so heb n = kjv n-1 (the title, heb 1, = kjv 1) and kjv n = heb n+1. Other pairs have no
/// known rule: the number is kept and [exact] is false, so the reader can say which numbering it follows.
({int verse, bool exact}) mapVerse(int verse, String from, String to) {
  if (from == to) return (verse: verse, exact: true);
  if (from == 'heb' && to == 'kjv') return (verse: verse <= 1 ? 1 : verse - 1, exact: true);
  if (from == 'kjv' && to == 'heb') return (verse: verse + 1, exact: true);
  return (verse: verse, exact: false);
}

/// The verses [annotation] is shown on in a chapter numbered [numbering] that ends at [lastVerse] (a mark past the end,
/// e.g. on a verse Norsk runs into its last one, goes to the last verse).
({int start, int end, bool exact}) shownRange(BibleAnnotation annotation, String numbering, {int? lastVerse}) {
  final start = mapVerse(annotation.verseStart, annotation.numbering, numbering);
  final end = mapVerse(annotation.verseEnd, annotation.numbering, numbering);
  int clamp(int v) => lastVerse != null && v > lastVerse ? lastVerse : v;
  return (start: clamp(start.verse), end: clamp(end.verse), exact: start.exact && end.exact);
}
