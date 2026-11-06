import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class JobChatApi {
  final DioClient _dioClient = locator<DioClient>();

  /// No parameters: the newest messages. [after]: only newer ones. [before]: the page of older ones.
  /// [reactionsSince]: also the reactions changed since then (the previous answer's `reactionsNext`).
  Future<dynamic> getChat(num jobId, {num? after, num? before, String? reactionsSince}) async =>
      (await _dioClient.dio.get(
        "/job/$jobId/chat",
        queryParameters: {"after": after, "before": before, "reactionsSince": ?reactionsSince},
      )).data;

  /// [reaction] LIKE or DISLIKE; null takes the user's reaction back.
  Future<dynamic> react(num jobId, num messageId, String? reaction) async => reaction == null
      ? (await _dioClient.dio.delete("/job/$jobId/chat/messages/$messageId/reaction")).data
      : (await _dioClient.dio.put("/job/$jobId/chat/messages/$messageId/reaction", data: {"type": reaction})).data;

  Future<dynamic> send(num jobId, String text) async =>
      (await _dioClient.dio.post("/job/$jobId/chat", data: {"text": text})).data;

  Future<dynamic> getPeople(num jobId) async => (await _dioClient.dio.get("/job/$jobId/chat/members")).data;

  Future<dynamic> addMember(num jobId, num userId) async =>
      (await _dioClient.dio.post("/job/$jobId/chat/members", data: {"userId": userId})).data;

  Future<dynamic> removeMember(num jobId, num userId) async =>
      (await _dioClient.dio.delete("/job/$jobId/chat/members/$userId")).data;

  Future<dynamic> setMuted(num jobId, bool muted) async =>
      (await _dioClient.dio.put("/job/$jobId/chat/mute", data: {"muted": muted})).data;
}
