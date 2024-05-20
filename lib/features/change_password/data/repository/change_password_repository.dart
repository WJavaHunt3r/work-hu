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
}