import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class ReadingPlanApi {
  final DioClient _dioClient = locator<DioClient>();

  /// The plan to show, or null when there is none (the backend answers 204). [language] picks the language of its
  /// title and description.
  Future<Map<String, dynamic>?> getCurrent(String language) async {
    final res = await _dioClient.dio.get("/reading-plan/current", queryParameters: {"lang": language});
    return res.statusCode == 204 || res.data is! Map ? null : res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> mark(num planId, int item) async =>
      (await _dioClient.dio.put("/reading-plan/$planId/items/$item")).data as Map<String, dynamic>;

  Future<Map<String, dynamic>> unmark(num planId, int item) async =>
      (await _dioClient.dio.delete("/reading-plan/$planId/items/$item")).data as Map<String, dynamic>;

  Future<Map<String, dynamic>> getLeaderboard(num planId, {int page = 0, int size = 100}) async =>
      (await _dioClient.dio.get(
            "/reading-plan/$planId/leaderboard",
            queryParameters: {"page": page, "size": size},
          )).data
          as Map<String, dynamic>;

  /// The published articles, titled in [language] where they are translated.
  Future<List<dynamic>> getArticles(num planId, String language) async =>
      (await _dioClient.dio.get("/reading-plan/$planId/articles", queryParameters: {"lang": language})).data
          as List<dynamic>;

  Future<Map<String, dynamic>> getArticle(num planId, num id, String language) async =>
      (await _dioClient.dio.get("/reading-plan/$planId/articles/$id", queryParameters: {"lang": language})).data
          as Map<String, dynamic>;

  Future<Map<String, dynamic>> markArticleRead(num planId, num id) async =>
      (await _dioClient.dio.put("/reading-plan/$planId/articles/$id/read")).data as Map<String, dynamic>;

  Future<Map<String, dynamic>> unmarkArticleRead(num planId, num id) async =>
      (await _dioClient.dio.delete("/reading-plan/$planId/articles/$id/read")).data as Map<String, dynamic>;

  // Managing (READING_PLAN_MANAGE)

  Future<List<dynamic>> getAllArticles(num planId) async =>
      (await _dioClient.dio.get("/reading-plan/$planId/admin/articles")).data as List<dynamic>;

  Future<Map<String, dynamic>> getAnyArticle(num planId, num id) async =>
      (await _dioClient.dio.get("/reading-plan/$planId/admin/articles/$id")).data as Map<String, dynamic>;

  Future<Map<String, dynamic>> createArticle(num planId, Map<String, dynamic> data) async =>
      (await _dioClient.dio.post("/reading-plan/$planId/admin/articles", data: data)).data as Map<String, dynamic>;

  Future<Map<String, dynamic>> updateArticle(num planId, num id, Map<String, dynamic> data) async =>
      (await _dioClient.dio.put("/reading-plan/$planId/admin/articles/$id", data: data)).data as Map<String, dynamic>;

  Future<void> deleteArticle(num planId, num id) async =>
      _dioClient.dio.delete("/reading-plan/$planId/admin/articles/$id");

  Future<Map<String, dynamic>> getArticleTranslation(num planId, num id, String language) async =>
      (await _dioClient.dio.get("/reading-plan/$planId/admin/articles/$id/translations/$language")).data
          as Map<String, dynamic>;

  Future<Map<String, dynamic>> saveArticleTranslation(
    num planId,
    num id,
    String language,
    Map<String, dynamic> data,
  ) async =>
      (await _dioClient.dio.put("/reading-plan/$planId/admin/articles/$id/translations/$language", data: data)).data
          as Map<String, dynamic>;

  Future<void> deleteArticleTranslation(num planId, num id, String language) async =>
      _dioClient.dio.delete("/reading-plan/$planId/admin/articles/$id/translations/$language");
}
