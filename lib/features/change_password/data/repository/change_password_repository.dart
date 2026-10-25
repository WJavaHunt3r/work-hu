import 'package:dio/dio.dart';
import 'package:work_hu/features/change_password/data/api/change_password_api.dart';

class ChangePasswordRepository {
  final ChangePasswordApi _changePasswordApi;

  ChangePasswordRepository(this._changePasswordApi);

  Future<String> changePassword(String username, String oldPassword, String newPassword) async {
    try {
      return await _changePasswordApi.changePassword(username, oldPassword, newPassword);
    } on DioException {
      rethrow;
    }
  }

  /// Returns the new access token for this device.
  Future<String> changeOwnPassword(String currentPassword, String newPassword, String refreshToken) async {
    final res = await _changePasswordApi.changeOwnPassword(currentPassword, newPassword, refreshToken);
    return (res as Map)['accessToken'] as String;
  }

  Future<void> requestReset(String usernameOrEmail) => _changePasswordApi.requestReset(usernameOrEmail);

  Future<void> checkReset(String token) => _changePasswordApi.checkReset(token);

  Future<void> confirmReset(String token, String newPassword) => _changePasswordApi.confirmReset(token, newPassword);
}
