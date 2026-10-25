import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

/// The signed-in user's highlights, notes and bookmarks (`/bible/annotations`).
class BibleAnnotationApi {
  DioClient get _dioClient => locator<DioClient>();

  /// `{next, annotations}`: all of them without [since], else the changes since then (deletions included).
  Future<Map<String, dynamic>> getChanges(String? since) async =>
      (await _dioClient.dio.get("/bible/annotations", queryParameters: {"since": ?since})).data as Map<String, dynamic>;

  Future<void> save(String id, Map<String, dynamic> annotation) =>
      _dioClient.dio.put("/bible/annotations/$id", data: annotation);

  Future<void> delete(String id) => _dioClient.dio.delete("/bible/annotations/$id");
}
