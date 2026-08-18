import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
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
    final String? token = await _storage.read(key: 'jwt_token');

    if (token != null) {
      try {
        final res = await _dio.dio.get("/user/me");

        _user = UserModel.fromJson(res.data);
      } catch (e) {
        await _storage.delete(key: 'jwt_token');
        _user = null;
      }
    }
  }

  // Call this during your standard login method
  Future<void> loginSuccess(UserModel user, String token) async {
    await _storage.write(key: 'jwt_token', value: token);
    _user = user;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');

    await _dio.dio.post('/auth/logout', queryParameters: {"refreshToken": await _storage.read(key: 'refresh_token')});
    await _storage.delete(key: 'refresh_token');
    setUser(null);
  }
}
