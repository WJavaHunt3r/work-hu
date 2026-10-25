/// A public note on verses of a plan's item (psalm), readable by the church members taking part (`/reading-plan/{id}/public-notes`).
/// [numbering] is the chapter's verse numbering label in [translation] where it was written. [hidden] and [reportCount]
/// come for managers ([hidden] also for the author of a hidden note).
class PublicNote {
  const PublicNote({
    required this.id,
    required this.item,
    required this.verseStart,
    required this.verseEnd,
    required this.translation,
    required this.numbering,
    required this.text,
    required this.author,
    required this.mine,
    required this.reportedByMe,
    required this.hidden,
    this.reportCount,
    this.createdAt,
  });

  final num id;
  final int item;
  final int verseStart;
  final int verseEnd;
  final String translation;
  final String numbering;
  final String text;
  final String author;
  final bool mine;
  final bool reportedByMe;
  final bool hidden;
  final int? reportCount;
  final DateTime? createdAt;

  factory PublicNote.fromJson(Map<String, dynamic> json) => PublicNote(
    id: json['id'] as num,
    item: (json['item'] as num).toInt(),
    verseStart: (json['verseStart'] as num).toInt(),
    verseEnd: (json['verseEnd'] as num).toInt(),
    translation: json['translation'] as String? ?? '',
    numbering: json['numbering'] as String? ?? 'kjv',
    text: json['text'] as String? ?? '',
    author: json['author'] as String? ?? '',
    mine: json['mine'] == true,
    reportedByMe: json['reportedByMe'] == true,
    hidden: json['hidden'] == true,
    reportCount: (json['reportCount'] as num?)?.toInt(),
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
  );
}

/// A reported note for the managers, with the reasons given (newest first).
class ReportedNote {
  const ReportedNote(this.note, this.reasons);

  final PublicNote note;
  final List<String?> reasons;

  factory ReportedNote.fromJson(Map<String, dynamic> json) => ReportedNote(
    PublicNote.fromJson(json['note'] as Map<String, dynamic>),
    [for (final r in json['reports'] as List? ?? const []) (r as Map)['reason'] as String?],
  );
}
