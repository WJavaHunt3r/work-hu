/// One period of a reading plan: the items to read and the days to do it in.
class ReadingPlanWeek {
  const ReadingPlanWeek({
    required this.weekNumber,
    required this.startItem,
    required this.endItem,
    required this.startsOn,
    required this.endsOn,
  });

  final int weekNumber;
  final int startItem;
  final int endItem;
  final DateTime startsOn;
  final DateTime endsOn;

  int get size => endItem - startItem + 1;

  bool contains(int item) => item >= startItem && item <= endItem;

  factory ReadingPlanWeek.fromJson(Map<String, dynamic> json) => ReadingPlanWeek(
    weekNumber: json['weekNumber'] as int,
    startItem: json['startItem'] as int,
    endItem: json['endItem'] as int,
    startsOn: DateTime.parse(json['startsOn'] as String),
    endsOn: DateTime.parse(json['endsOn'] as String),
  );
}

/// The community reading challenge (e.g. the 150 psalms) with the signed-in user's progress.
/// [open] is false before the start and after the end, when nothing can be marked any more.
class ReadingPlanModel {
  const ReadingPlanModel({
    required this.id,
    required this.title,
    required this.bookKey,
    required this.itemCount,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.open,
    required this.weeks,
    required this.myItems,
    required this.participants,
    required this.totalReadings,
  });

  final num id;
  final String title;
  final String bookKey;
  final int itemCount;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final bool open;
  final List<ReadingPlanWeek> weeks;
  final Set<int> myItems;
  final int participants;
  final int totalReadings;

  int get readCount => myItems.length;
  int get remaining => itemCount - readCount;
  double get progress => itemCount == 0 ? 0 : readCount / itemCount;

  /// The first item not read yet, or null when everything is read.
  int? get nextUnread {
    for (var n = 1; n <= itemCount; n++) {
      if (!myItems.contains(n)) return n;
    }
    return null;
  }

  /// The week that is on [today]; before the plan the first, after it the last.
  ReadingPlanWeek? weekOn(DateTime today) {
    if (weeks.isEmpty) return null;
    final day = DateTime(today.year, today.month, today.day);
    for (final w in weeks) {
      if (!day.isBefore(w.startsOn) && !day.isAfter(w.endsOn)) return w;
    }
    return day.isBefore(weeks.first.startsOn) ? weeks.first : weeks.last;
  }

  /// Items of [week] read so far.
  int readIn(ReadingPlanWeek week) => myItems.where(week.contains).length;

  /// Days left to read in, counting today; at least 1 while the plan is open.
  int daysLeft(DateTime today) {
    final day = DateTime(today.year, today.month, today.day);
    return endDate.difference(day).inDays + 1;
  }

  ReadingPlanModel withItems(Set<int> items) => ReadingPlanModel(
    id: id,
    title: title,
    bookKey: bookKey,
    itemCount: itemCount,
    startDate: startDate,
    endDate: endDate,
    description: description,
    open: open,
    weeks: weeks,
    myItems: items,
    participants: participants,
    totalReadings: totalReadings,
  );

  factory ReadingPlanModel.fromJson(Map<String, dynamic> json) => ReadingPlanModel(
    id: json['id'] as num,
    title: json['title'] as String? ?? '',
    bookKey: json['bookKey'] as String? ?? '',
    itemCount: json['itemCount'] as int? ?? 0,
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
    description: json['description'] as String? ?? '',
    open: json['open'] as bool? ?? false,
    weeks: [for (final w in (json['weeks'] as List? ?? const [])) ReadingPlanWeek.fromJson(w as Map<String, dynamic>)],
    myItems: {for (final n in (json['myItems'] as List? ?? const [])) (n as num).toInt()},
    participants: (json['participants'] as num?)?.toInt() ?? 0,
    totalReadings: (json['totalReadings'] as num?)?.toInt() ?? 0,
  );
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.name,
    required this.count,
    this.articlePoints = 0,
  });

  final int rank;
  final num userId;
  final String name;

  /// Points: the items read plus the points of the articles read.
  final int count;

  /// The part of [count] that comes from articles.
  final int articlePoints;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => LeaderboardEntry(
    rank: json['rank'] as int,
    userId: json['userId'] as num,
    name: json['name'] as String? ?? '',
    count: json['count'] as int? ?? 0,
    articlePoints: json['articlePoints'] as int? ?? 0,
  );
}

/// One page of the ranking and where the signed-in user stands ([myRank] is null before the first item).
class LeaderboardModel {
  const LeaderboardModel({
    required this.entries,
    required this.total,
    required this.myRank,
    required this.myCount,
    required this.myPoints,
    this.myArticlePoints = 0,
  });

  final List<LeaderboardEntry> entries;
  final int total;
  final int? myRank;

  /// Items the user has read.
  final int myCount;

  /// The user's points: items plus article points.
  final int myPoints;
  final int myArticlePoints;

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) => LeaderboardModel(
    entries: [
      for (final e in (json['entries'] as List? ?? const [])) LeaderboardEntry.fromJson(e as Map<String, dynamic>),
    ],
    total: (json['total'] as num?)?.toInt() ?? 0,
    myRank: (json['myRank'] as num?)?.toInt(),
    myCount: (json['myCount'] as num?)?.toInt() ?? 0,
    // An older backend has no points: they were the items
    myPoints: (json['myPoints'] as num?)?.toInt() ?? (json['myCount'] as num?)?.toInt() ?? 0,
    myArticlePoints: (json['myArticlePoints'] as num?)?.toInt() ?? 0,
  );
}

/// One verse of the bundled Károli text.
class Verse {
  const Verse(this.number, this.text);

  final int number;
  final String text;
}

/// An article of the reading plan, read for extra [points]. [body] (a Quill delta as JSON text) is only there when one
/// article was asked for, not in lists. Drafts ([published] false) are only seen by the people who manage the plan.
class ReadingArticle {
  const ReadingArticle({
    required this.id,
    required this.title,
    required this.points,
    required this.read,
    required this.published,
    this.createdDateTime,
    this.body,
    this.language = 'hu',
    this.languages = const [],
  });

  final num id;
  final String title;
  final int points;
  final bool read;
  final bool published;
  final DateTime? createdDateTime;
  final String? body;

  /// The language [title] and [body] are in: the reader's when the article is translated, else the default (Hungarian).
  final String language;

  /// Only for managers: the default language and the ones the article has been translated into.
  final List<String> languages;

  factory ReadingArticle.fromJson(Map<String, dynamic> json) => ReadingArticle(
    id: json['id'] as num,
    title: json['title'] as String? ?? '',
    points: (json['points'] as num?)?.toInt() ?? 1,
    read: json['read'] as bool? ?? false,
    published: json['published'] as bool? ?? false,
    createdDateTime: DateTime.tryParse(json['createdDateTime'] as String? ?? ''),
    body: json['body'] as String?,
    language: json['language'] as String? ?? 'hu',
    languages: [for (final l in (json['languages'] as List? ?? const [])) l as String],
  );
}
