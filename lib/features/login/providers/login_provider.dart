import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_service.dart';
import 'package:work_hu/features/home/data/api/team_api.dart';
import 'package:work_hu/features/home/data/repository/teams_repository.dart';
import 'package:work_hu/features/home/data/state/team_state.dart';
import 'package:work_hu/features/login/data/api/login_api.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/data/state/login_state.dart';
import 'package:work_hu/features/utils.dart';

import '../../../work_hu_app.dart';

final loginApiProvider = Provider<LoginApi>((ref) => LoginApi());

final loginRepoProvider = Provider<LoginRepository>((ref) => LoginRepository(ref.read(loginApiProvider)));

final loginDataProvider =
    StateNotifierProvider<LoginDataNotifier, LoginState>((ref) => LoginDataNotifier(ref.read(loginRepoProvider), ref.read(routerProvider)));

class LoginDataNotifier extends StateNotifier<LoginState> {
  LoginDataNotifier(this.loginRepository, this.router) : super(const LoginState()) {
    usernameController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");

    usernameController.addListener(_updateState);
    passwordController.addListener(_updateState);
  }

  final LoginRepository loginRepository;
  final GoRouter router;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  Future<void> login() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await loginRepository.login(state.username, state.password).then((data) async {
        await loginRepository.getUser(data['username']).then((value) {
          locator<UserService>().setUser(value);
          Utils.saveData("username", state.username);
          Utils.saveData("password", state.password);
          state = state.copyWith(username: "", password: "", modelState: ModelState.success);
          if(router.canPop()){
            router.pop();
          }
          _clear();

        });
      });
    } on DioError catch (e) {
      // if(e.type == DioErrorType.)
      state = state.copyWith(username: "", password: "", modelState: ModelState.error, message: e.message);
    }
  }

  void _updateState() {
    state = state.copyWith(username: usernameController.value.text, password: passwordController.value.text);
  }

  void _clear() {
    usernameController.clear();
    passwordController.clear();
    state = state.copyWith(username: "", password: "", modelState: ModelState.empty);
  }
}
