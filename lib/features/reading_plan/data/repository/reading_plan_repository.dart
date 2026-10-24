import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/reading_plan/data/api/reading_plan_api.dart';
import 'package:work_hu/features/reading_plan/data/model/reading_plan_model.dart';

class ReadingPlanRepository {
  ReadingPlanRepository(this._api);

  final ReadingPlanApi _api;

  Future<ReadingPlanModel?> getCurrent(String language) => guardApi(() async {
    final json = await _api.getCurrent(language);
    return json == null ? null : ReadingPlanModel.fromJson(json);
  });

  /// Marks or un-marks an item; answers the user's items as the server now has them.
  Future<Set<int>> setRead(num planId, int item, {required bool read}) => guardApi(() async {
    final json = read ? await _api.mark(planId, item) : await _api.unmark(planId, item);
    return {for (final n in (json['myItems'] as List)) (n as num).toInt()};
  });

  Future<LeaderboardModel> getLeaderboard(num planId) =>
      guardApi(() async => LeaderboardModel.fromJson(await _api.getLeaderboard(planId)));

  Future<List<ReadingArticle>> getArticles(num planId, String language) => guardApi(() async {
    final res = await _api.getArticles(planId, language);
    return [for (final a in res) ReadingArticle.fromJson(a as Map<String, dynamic>)];
  });

  Future<ReadingArticle> getArticle(num planId, num id, String language) =>
      guardApi(() async => ReadingArticle.fromJson(await _api.getArticle(planId, id, language)));

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
