import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/utils.dart';

final userDataProvider = ChangeNotifierProvider<UserProvider>((ref) => locator<UserProvider>());

@lazySingleton
class UserProvider extends ChangeNotifier {
  // initUser() is run once at startup by authInitProvider.
  UserProvider();

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

    final String token = await Utils.getData('jwt_token');

    if (!keepLoggedIn) {
      if (token.isNotEmpty) await logout();
      return;
    }

    if (token.isNotEmpty) {
      try {
        final res = await _dio.dio.get("/user/me");

        _user = UserModel.fromJson(res.data);
      } on DioException catch (e) {
        // Expired or revoked sessions are cleared by DioClient's refresh handling.
        // Keep the tokens on network errors or timeouts so the next start can restore the session.
        final status = e.response?.statusCode;
        if (status == 401 || status == 403) {
          await Utils.deleteData('jwt_token');
        }
        _user = null;
      } catch (e) {
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
    final token = _token ?? await Utils.getData('jwt_token');
    final refreshToken = await Utils.getData('refresh_token');

    await Utils.deleteData('jwt_token');
    await Utils.deleteData('refresh_token');
    // await GoogleSignIn.instance.signOut();
    await setUser(null);

    // Uses the interceptor-free Dio: logout is also called from inside DioClient's queued error
    // interceptor, where a request through the main Dio would deadlock or loop on 401.
    try {
      await _dio.plainDio.post('/auth/logout',
          queryParameters: {"refreshToken": refreshToken},
          options: Options(headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'}));
    } catch (_) {
      // The local session is already cleared; a failed server-side revoke is not fatal.
    }
  }
}
