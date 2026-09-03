import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/utils.dart';

final userDataProvider = ChangeNotifierProvider<UserProvider>((ref) => locator<UserProvider>());

@lazySingleton
class UserProvider extends ChangeNotifier {
  UserProvider() {
    initUser();
  }

  UserModel? _user;
  String? _token;
  final _dio = locator<DioClient>();

  Future<void> setUser(UserModel? user) async {
    if (user == null) {
      await Utils.saveData('user', '');
      await Utils.saveData('password', '');
      await Utils.saveData('jwt_token', '');
      _token = null;
    }
    _user = user;
    notifyListeners();
  }

  Future<void> setToken(String? token) async {
    _token = token;
  }

  UserModel? get user => _user;

  String? get token => _token;

  Future<void> initUser() async {
    final keepLoggedIn = await Utils.getData('keep_logged_in') == 'true';

    if (!keepLoggedIn) {
      await logout();
      return;
    }
    final String token = await Utils.getData('jwt_token');

    if (token.isNotEmpty) {
      try {
        final res = await _dio.dio.get("/user/me");

        _user = UserModel.fromJson(res.data);
      } catch (e) {
        await Utils.deleteData('jwt_token');
        _user = null;
      }
    }
  }

  // Call this during your standard login method
  Future<void> loginSuccess(UserModel user, String token) async {
    await Utils.saveData('jwt_token', token);
    _user = user;
  }

  Future<void> logout() async {
    await Utils.deleteData('jwt_token');

    await _dio.dio.post('/auth/logout', queryParameters: {"refreshToken": await Utils.getData('refresh_token')});
    await Utils.deleteData('refresh_token');
    setUser(null);
  }
}
