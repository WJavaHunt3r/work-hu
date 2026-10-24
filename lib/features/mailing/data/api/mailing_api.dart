import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class MailingApi {
  final DioClient _dioClient = locator<DioClient>();

  Future<dynamic> getRecipients() async => (await _dioClient.dio.get("/mailing/recipients")).data;

  Future<void> sendTest(String subject, String body) async =>
      _dioClient.dio.post("/mailing/test", data: {"subject": subject, "body": body});

  Future<dynamic> send(String subject, String body) async =>
      (await _dioClient.dio.post("/mailing", data: {"subject": subject, "body": body})).data;

  Future<dynamic> getHistory(int page) async =>
      (await _dioClient.dio.get("/mailing", queryParameters: {"page": page, "size": 20})).data;
}
