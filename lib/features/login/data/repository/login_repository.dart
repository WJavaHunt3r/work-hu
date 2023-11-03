import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:work_hu/features/login/data/api/login_api.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

class LoginRepository {
  final LoginApi _loginApi;

  LoginRepository(this._loginApi);

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final res = await _loginApi.loginRequest(username, password);
      return res;
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUser(String username) async {
    try {
      final res = await _loginApi.getUser(username);
      return UserModel.fromJson(res);
    } on DioError catch (e) {
      rethrow;
    }
  }
}
