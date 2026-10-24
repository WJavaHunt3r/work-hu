import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class StreamApi {
  final DioClient _dioClient = locator<DioClient>();

  Future<List<dynamic>> getStreams() async => (await _dioClient.dio.get("/streams")).data;

  Future<List<dynamic>> getLiveStreams() async => (await _dioClient.dio.get("/streams/live")).data;

  Future<dynamic> startStream(String title, String language) async =>
      (await _dioClient.dio.post("/streams", data: {"title": title, "language": language})).data;

  Future<dynamic> updateStream(String uid, String title, String language) async =>
      (await _dioClient.dio.put("/streams/$uid", data: {"title": title, "language": language})).data;

  Future<void> deleteStream(String uid) async => _dioClient.dio.delete("/streams/$uid");
}
