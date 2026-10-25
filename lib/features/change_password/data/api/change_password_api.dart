import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class ChangePasswordApi {
  final DioClient _dioClient = locator<DioClient>();

  ChangePasswordApi();

  Future<dynamic> changePassword(String username, String oldPassword, String newPassword) async {
    try {
      final res = await _dioClient.dio.post(
        "/auth/changePassword",
        data: {'username': username, "oldPassword": oldPassword, "newPassword": newPassword},
      );
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  /// The signed-in user changes their own password; the backend checks the current one (400 with the reason otherwise)
  /// and signs out every other device: [refreshToken] (this device's) is kept, the answer holds a new `accessToken`.
  Future<dynamic> changeOwnPassword(String currentPassword, String newPassword, String refreshToken) async {
    final res = await _dioClient.dio.post(
      "/user/me/password",
      data: {'currentPassword': currentPassword, 'newPassword': newPassword, 'refreshToken': refreshToken},
    );
    return res.data;
  }

  /// E-mails a one-time reset link when the account exists (the answer is the same either way).
  Future<dynamic> requestReset(String usernameOrEmail) async {
    final res = await _dioClient.plainDio.post("/auth/password-reset/request", data: {'username': usernameOrEmail});
    return res.data;
  }

  /// 200 when the reset link can still be used, 410 otherwise.
  Future<dynamic> checkReset(String token) async {
    final res = await _dioClient.plainDio.post("/auth/password-reset/check", data: {'token': token});
    return res.data;
  }

  /// Sets the new password with a reset link (400 too short, 410 link not usable); signs out every device.
  Future<dynamic> confirmReset(String token, String newPassword) async {
    final res = await _dioClient.plainDio.post(
      "/auth/password-reset/confirm",
      data: {'token': token, 'newPassword': newPassword},
    );
    return res.data;
  }
}
