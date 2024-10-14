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
    } on DioException {
      rethrow;
    }
  }

  Future<UserModel> getUserByUsername(String username) async {
    try {
      final res = await _loginApi.getUserByUsername(username);
      return UserModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<UserModel> getUser(num id) async {
    try {
      final res = await _loginApi.getUser(id);
      return UserModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<String> sendNewPassword(String username) async {
    try {
      final res = await _loginApi.sendNewPassword(username);
      return res;
    } on DioException {
      rethrow;
    }
  }
}
