import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/login/data/api/login_api.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/data/state/login_state.dart';
import 'package:work_hu/features/utils.dart';

import '../../../work_hu_app.dart';

final loginApiProvider = Provider<LoginApi>((ref) => LoginApi());

final loginRepoProvider = Provider<LoginRepository>((ref) => LoginRepository(ref.read(loginApiProvider)));

final loginDataProvider = StateNotifierProvider<LoginDataNotifier, LoginState>((ref) =>
    LoginDataNotifier(ref.read(loginRepoProvider), ref.read(routerProvider), ref.read(userDataProvider.notifier)));

class LoginDataNotifier extends StateNotifier<LoginState> {
  LoginDataNotifier(this.loginRepository, this.router, this.userSessionProvider) : super(const LoginState()) {
    usernameController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");

    usernameController.addListener(_updateState);
    passwordController.addListener(_updateState);
  }

  final LoginRepository loginRepository;
  final GoRouter router;
  final UserDataNotifier userSessionProvider;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  Future<void> login() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await loginRepository.login(state.username, Utils.encrypt(state.password)).then((data) async {
        await loginRepository.getUser(data['username']).then((user) async {
          if (user.changedPassword) {
            userSessionProvider.setUser(user);
            await Utils.saveData('user', state.username).then((value) async {
              await Utils.saveData('password', state.password).then((value) {
                state = state.copyWith(username: "", password: "", modelState: ModelState.success);
                router.go("/home");
                _clear();
              });
            });
          } else {
            router.push("/changePassword").then((success) {
              success != null && success as bool
                  ? _clear("login_password_changed_success".i18n(), ModelState.error)
                  : _clear("login_password_changed_failed".i18n(), ModelState.error);
            });
          }
        });
      });
    } on DioException {
      // if(e.type == DioErrorType.)
      state = state.copyWith(
          username: "", password: "", modelState: ModelState.error, message: "Wrong username or password");
    }
  }

  void _updateState() {
    state = state.copyWith(username: usernameController.value.text, password: passwordController.value.text);
  }

  void _clear([String? s, ModelState? modelState]) {
    usernameController.clear();
    passwordController.clear();
    state = state.copyWith(username: "", password: "", modelState: modelState ?? ModelState.empty, message: s ?? "");
  }

  Future<void> clearResetState() async {
    state = state.copyWith(resetState: ModelState.empty);
  }

  Future<void> reset() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await loginRepository.sendNewPassword(state.username);
      state = state.copyWith(
          modelState: ModelState.success, resetState: ModelState.success, message: "Új jelszó emailben elküldve");
    } on DioException catch (e) {
      usernameController.text = "";
      passwordController.text = "";
      state = state.copyWith(
          username: "", password: "", modelState: ModelState.error, message: "Nem létező felhasználónév");
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }
}
