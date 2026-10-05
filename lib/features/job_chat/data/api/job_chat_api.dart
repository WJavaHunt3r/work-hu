import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class JobChatApi {
  final DioClient _dioClient = locator<DioClient>();

  /// No parameters: the newest messages. [after]: only newer ones. [before]: the page of older ones.
  Future<dynamic> getChat(num jobId, {num? after, num? before}) async =>
      (await _dioClient.dio.get("/job/$jobId/chat", queryParameters: {"after": after, "before": before})).data;

  Future<dynamic> send(num jobId, String text) async =>
      (await _dioClient.dio.post("/job/$jobId/chat", data: {"text": text})).data;

  Future<dynamic> setMuted(num jobId, bool muted) async =>
      (await _dioClient.dio.put("/job/$jobId/chat/mute", data: {"muted": muted})).data;
}
