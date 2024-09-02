import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/dukapp.dart';
import 'package:work_hu/features/login/data/api/login_api.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/data/state/login_state.dart';
import 'package:work_hu/features/utils.dart';

final loginApiProvider = Provider<LoginApi>((ref) => LoginApi());

final loginRepoProvider = Provider<LoginRepository>((ref) => LoginRepository(ref.read(loginApiProvider)));

final loginDataProvider = StateNotifierProvider<LoginDataNotifier, LoginState>(
    (ref) => LoginDataNotifier(ref.read(loginRepoProvider), ref.read(userDataProvider.notifier)));

class LoginDataNotifier extends StateNotifier<LoginState> {
  LoginDataNotifier(this.loginRepository, this.userSessionProvider) : super(const LoginState()) {
    usernameController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");

    usernameController.addListener(_updateState);
    passwordController.addListener(_updateState);
  }

  final LoginRepository loginRepository;
  final UserDataNotifier userSessionProvider;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  Future<void> login() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      var user = await loginWithSavedData(state.username.trim(), state.password.trim());

      if (user != null) {
        if (user.changedPassword) {
          await Utils.saveData('user', state.username).then((value) async {
            await Utils.saveData('password', state.password);
          });
        }
        clear("", ModelState.success);
      } else {
        clear("", ModelState.error);
      }
    } on DioException {
      // if(e.type == DioErrorType.)
      state = state.copyWith(
          username: "", password: "", modelState: ModelState.error, message: "login_username_password_error".i18n());
    }
  }

  Future<UserModel?> loginWithSavedData([String? username, String? password]) async {
    var usr = username ?? await Utils.getData('user');
    var pswd = password ?? await Utils.getData('password');
    if (usr.isEmpty || pswd.isEmpty) {
      return null;
    }
    UserModel? user;
    await loginRepository.login(usr, Utils.encrypt(pswd)).then((data) async {
      await loginRepository.getUser(data['username']).then((userData) async {
        if (userData.changedPassword) {
          userSessionProvider.setUser(userData);
        }
        user = userData;
      });
    });
    return user;
  }

  void _updateState() {
    state = state.copyWith(username: usernameController.value.text, password: passwordController.value.text);
  }

  void clear([String? s, ModelState? modelState]) {
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
