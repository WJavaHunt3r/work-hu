import 'package:dio/dio.dart' show Options;
import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

/// Device registration and notification preferences. Paths follow the backend's `/notifications` controller.
class NotificationApi {
  final DioClient _dioClient = locator<DioClient>();

  Future<void> registerDevice({required String token, required String platform}) async {
    await _dioClient.dio.post("/notifications/devices", data: {"token": token, "platform": platform});
  }

  /// Uses the interceptor-free Dio when [bearer] is given: it runs during logout, when the normal client's
  /// token handling would loop on 401.
  Future<void> unregisterDevice({required String token, String? bearer}) async {
    final client = bearer == null ? _dioClient.dio : _dioClient.plainDio;
    await client.delete(
      "/notifications/devices",
      queryParameters: {"token": token},
      options: bearer == null ? null : Options(headers: {'Authorization': 'Bearer $bearer'}),
    );
  }

  Future<dynamic> getPreferences() async => (await _dioClient.dio.get("/notifications/preferences")).data;

  /// Body is `{TYPE: enabled}`; types left out keep their setting. Returns the full list.
  Future<dynamic> putPreferences(Map<String, bool> changes) async =>
      (await _dioClient.dio.put("/notifications/preferences", data: changes)).data;
}
