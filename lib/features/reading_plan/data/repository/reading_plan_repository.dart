import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/reading_plan/data/api/reading_plan_api.dart';
import 'package:work_hu/features/reading_plan/data/model/reading_plan_model.dart';
import 'package:work_hu/features/reading_plan/data/store/reading_plan_cache.dart';

/// A server answer, or the copy kept on the device when the server could not be reached ([offline]).
typedef Cached<T> = ({T value, bool offline});

class ReadingPlanRepository {
  ReadingPlanRepository(this._api, [this._cache = const ReadingPlanCache()]);

  final ReadingPlanApi _api;
  final ReadingPlanCache _cache;

  ReadingPlanCache get cache => _cache;

  /// Asks the server and keeps the answer under [name] for [user] ([user] null: nothing is kept); offline it answers
  /// the kept copy, and rethrows when there is none.
  Future<Cached<T>> _cached<T>(
    String? user,
    String name,
    Future<Object?> Function() fetch,
    T Function(Object? json) parse,
  ) async {
    try {
      final json = await fetch();
      if (user != null) await _cache.write(user, name, json);
      return (value: parse(json), offline: false);
    } catch (e) {
      if (user == null || !isOfflineError(e)) rethrow;
      final saved = await _cache.read(user, name);
      if (!saved.hasValue) rethrow;
      return (value: parse(saved.json), offline: true);
    }
  }

  static String _currentName(String language) => 'current_$language';

  /// The current plan, kept for [user] to show offline.
  Future<Cached<ReadingPlanModel?>> getCurrentCached(String language, String? user) => guardApi(
    () => _cached(
      user,
      _currentName(language),
      () => _api.getCurrent(language),
      (json) => json is Map<String, dynamic> ? ReadingPlanModel.fromJson(json) : null,
    ),
  );

  /// The plan kept on the device for [user], without asking the server (null when there is none or no plan).
  Future<ReadingPlanModel?> savedCurrent(String language, String user) async {
    final json = (await _cache.read(user, _currentName(language))).json;
    return json is Map<String, dynamic> ? ReadingPlanModel.fromJson(json) : null;
  }

  /// Puts [items] into the kept copy of the plan, so it shows the marks the server has taken.
  Future<void> saveItems(String language, String user, Set<int> items) async {
    final json = (await _cache.read(user, _currentName(language))).json;
    if (json is! Map<String, dynamic>) return;
    await _cache.write(user, _currentName(language), {...json, 'myItems': (items.toList()..sort())});
  }

  /// Marks or un-marks an item; answers the user's items as the server now has them.
  Future<Set<int>> setRead(num planId, int item, {required bool read}) => guardApi(() async {
    final json = read ? await _api.mark(planId, item) : await _api.unmark(planId, item);
    return {for (final n in (json['myItems'] as List)) (n as num).toInt()};
  });

  /// The ranking of the user's own group (members or guests), or of [group] for managers; offline the one last seen
  /// by [user].
  Future<LeaderboardModel> getLeaderboard(num planId, {String? user, String? group}) async => (await guardApi(
    () => _cached(
      user,
      group == null ? 'leaderboard_$planId' : 'leaderboard_${planId}_$group',
      () => _api.getLeaderboard(planId, group: group),
      (json) => LeaderboardModel.fromJson(json as Map<String, dynamic>),
    ),
  )).value;

  /// The published articles; offline the list last seen by [user] in [language].
  Future<List<ReadingArticle>> getArticles(num planId, String language, {String? user}) async => (await guardApi(
    () => _cached(
      user,
      'articles_${planId}_$language',
      () => _api.getArticles(planId, language),
      (json) => [for (final a in json as List) ReadingArticle.fromJson(a as Map<String, dynamic>)],
    ),
  )).value;

  /// One article with its text; offline the copy [user] last opened in [language].
  Future<ReadingArticle> getArticle(num planId, num id, String language, {String? user}) async => (await guardApi(
    () => _cached(
      user,
      'article_${planId}_${id}_$language',
      () => _api.getArticle(planId, id, language),
      (json) => ReadingArticle.fromJson(json as Map<String, dynamic>),
    ),
  )).value;

  Future<ReadingArticle> setArticleRead(num planId, num id, {required bool read}) => guardApi(() async {
    final json = read ? await _api.markArticleRead(planId, id) : await _api.unmarkArticleRead(planId, id);
    return ReadingArticle.fromJson(json);
  });

  Future<List<ReadingArticle>> getAllArticles(num planId) => guardApi(() async {
    final res = await _api.getAllArticles(planId);
    return [for (final a in res) ReadingArticle.fromJson(a as Map<String, dynamic>)];
  });

  Future<ReadingArticle> getAnyArticle(num planId, num id) =>
      guardApi(() async => ReadingArticle.fromJson(await _api.getAnyArticle(planId, id)));

  /// Creates ([id] null) or changes an article; [body] is the Quill delta as JSON text.
  Future<ReadingArticle> saveArticle(
    num planId,
    num? id, {
    required String title,
    required String? body,
    required int points,
    required bool published,
  }) => guardApi(() async {
    final data = {"title": title, "body": body, "points": points, "published": published};
    final json = id == null ? await _api.createArticle(planId, data) : await _api.updateArticle(planId, id, data);
    return ReadingArticle.fromJson(json);
  });

  Future<void> deleteArticle(num planId, num id) => guardApi(() => _api.deleteArticle(planId, id));

  /// The translation of an article into [language] (title and body), or null when there is none yet.
  Future<ReadingArticle?> getArticleTranslation(num planId, num id, String language) async {
    try {
      return await guardApi(
        () async => ReadingArticle.fromJson(await _api.getArticleTranslation(planId, id, language)),
      );
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<ReadingArticle> saveArticleTranslation(
    num planId,
    num id,
    String language, {
    required String title,
    required String? body,
  }) => guardApi(
    () async => ReadingArticle.fromJson(
      await _api.saveArticleTranslation(planId, id, language, {"title": title, "body": body}),
    ),
  );

  Future<void> deleteArticleTranslation(num planId, num id, String language) =>
      guardApi(() => _api.deleteArticleTranslation(planId, id, language));
}
