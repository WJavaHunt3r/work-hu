import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class ChangePasswordApi {
  final DioClient _dioClient = locator<DioClient>();

  ChangePasswordApi();

  Future<dynamic> changePassword(String username, String oldPassword, String newPassword) async {
    try {
      final res = await _dioClient.dio.post("/auth/changePassword",
          data: {'username': username, "oldPassword": oldPassword, "newPassword": newPassword});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
