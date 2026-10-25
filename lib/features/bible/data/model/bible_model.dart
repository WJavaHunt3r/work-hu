import 'package:work_hu/features/reading_plan/data/model/reading_plan_model.dart' show Verse;

export 'package:work_hu/features/reading_plan/data/model/reading_plan_model.dart' show Verse;

/// A full-Bible translation as the backend lists it (`GET /bible/translations`). [version] changes whenever the text
/// does; [size] is the download in bytes.
class BibleTranslationInfo {
  const BibleTranslationInfo({
    required this.id,
    required this.shortName,
    required this.name,
    required this.language,
    this.year,
    this.version,
    this.size,
  });

  final String id;
  final String shortName;
  final String name;
  final String language;
  final int? year;
  final String? version;
  final int? size;

  factory BibleTranslationInfo.fromJson(Map<String, dynamic> json) => BibleTranslationInfo(
    id: json['id'] as String,
    shortName: json['shortName'] as String? ?? json['id'] as String,
    name: json['name'] as String? ?? json['id'] as String,
    language: json['language'] as String? ?? '',
    year: (json['year'] as num?)?.toInt(),
    version: json['version'] as String?,
    size: (json['size'] as num?)?.toInt(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'shortName': shortName,
    'name': name,
    'language': language,
    'year': year,
    'version': version,
    'size': size,
  };

  /// "Károli Biblia (1908)"; "Lutherbibel 1912" already has its year.
  String get fullName => year == null || name.contains('$year') ? name : '$name ($year)';
}

/// One book of a downloaded translation. [chapters] holds chapter 1 at index 0; verse numbers are kept as in the
/// text, so a verse a translation leaves out (WEB, Acts 8:37) is simply missing.
class BibleBook {
  const BibleBook({
    required this.osis,
    required this.bookId,
    required this.name,
    String? abbreviation,
    required this.newTestament,
    required this.chapters,
    this.numbering = const {},
  }) : abbreviation = abbreviation ?? name;

  /// OSIS code, the same in every translation: "Gen", "Ps", "John".
  final String osis;

  /// 1-66
  final int bookId;

  /// In the translation's language: "1 Mózes", "Johannes".
  final String name;

  /// Short name for the book grid: "1Móz", "Ján" (the full name in files built before abbreviations existed).
  final String abbreviation;
  final bool newTestament;
  final List<List<Verse>> chapters;

  /// The chapters numbered unlike KJV, by chapter number: "heb" (a psalm whose title is verse 1), "kar" (Károli's
  /// own numbering), ... Two translations number a chapter alike when [numberingOf] is the same for both.
  final Map<int, String> numbering;

  String numberingOf(int chapter) => numbering[chapter] ?? 'kjv';

  int get chapterCount => chapters.length;

  List<Verse>? chapter(int number) => number >= 1 && number <= chapters.length ? chapters[number - 1] : null;
}

/// A whole downloaded translation (`GET /bible/translations/{id}`).
class Bible {
  Bible({required this.id, required this.name, required this.books}) : _byOsis = {for (final b in books) b.osis: b};

  final String id;
  final String name;
  final List<BibleBook> books;
  final Map<String, BibleBook> _byOsis;

  BibleBook? book(String osis) => _byOsis[osis];

  factory Bible.fromJson(Map<String, dynamic> json) => Bible(
    id: json['id'] as String,
    name: json['name'] as String? ?? json['id'] as String,
    books: [
      for (final b in json['books'] as List)
        BibleBook(
          osis: b['book'] as String,
          bookId: (b['bookId'] as num).toInt(),
          name: b['name'] as String? ?? b['englishName'] as String? ?? b['book'] as String,
          abbreviation: b['abbreviation'] as String?,
          newTestament: b['testament'] == 'NT',
          chapters: [
            for (final c in b['chapters'] as List)
              [for (final v in c['verses'] as List) Verse((v['number'] as num).toInt(), v['text'] as String)],
          ],
          numbering: {
            for (final c in b['chapters'] as List)
              if (c['numbering'] != null) (c['chapter'] as num).toInt(): c['numbering'] as String,
          },
        ),
    ],
  );
}

/// A place in the Bible: a book (OSIS code) and a chapter.
class BiblePosition {
  const BiblePosition(this.osis, this.chapter, {this.label});

  final String osis;
  final int chapter;

  /// "János 3" in the translation it was read in, for the Home page's "Continue" (which then needs no download).
  /// Not part of equality.
  final String? label;

  /// "John.3"
  String encode() => '$osis.$chapter';

  static BiblePosition? decode(String? value) {
    if (value == null) return null;
    final dot = value.lastIndexOf('.');
    if (dot <= 0) return null;
    final chapter = int.tryParse(value.substring(dot + 1));
    return chapter == null ? null : BiblePosition(value.substring(0, dot), chapter);
  }

  /// The chapter before this one, across books (null before Genesis 1).
  BiblePosition? previous(Bible bible) {
    if (chapter > 1) return BiblePosition(osis, chapter - 1);
    final i = bible.books.indexWhere((b) => b.osis == osis);
    if (i <= 0) return null;
    final book = bible.books[i - 1];
    return BiblePosition(book.osis, book.chapterCount);
  }

  /// The chapter after this one, across books (null after the last chapter of Revelation).
  BiblePosition? next(Bible bible) {
    final i = bible.books.indexWhere((b) => b.osis == osis);
    if (i < 0) return null;
    if (chapter < bible.books[i].chapterCount) return BiblePosition(osis, chapter + 1);
    if (i + 1 >= bible.books.length) return null;
    return BiblePosition(bible.books[i + 1].osis, 1);
  }

  String get route => '/bible/$osis/$chapter';

  @override
  bool operator ==(Object other) => other is BiblePosition && other.osis == osis && other.chapter == chapter;

  @override
  int get hashCode => Object.hash(osis, chapter);
}

/// `?verse=` of a chapter link: "16" or "16-18"; null when missing or not a range.
({int start, int end})? parseVerseRange(String? value) {
  if (value == null) return null;
  final parts = value.split('-');
  final start = int.tryParse(parts.first);
  final end = parts.length == 2 ? int.tryParse(parts[1]) : start;
  if (parts.length > 2 || start == null || end == null || start < 1 || end < start) return null;
  return (start: start, end: end);
}
