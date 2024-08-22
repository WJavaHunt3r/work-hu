import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/dukapp.dart';
import 'package:work_hu/features/change_password/data/api/change_password_api.dart';
import 'package:work_hu/features/change_password/data/repository/change_password_repository.dart';
import 'package:work_hu/features/change_password/data/state/change_password_state.dart';
import 'package:work_hu/features/utils.dart';

final changePasswordApiProvider = Provider<ChangePasswordApi>((ref) => ChangePasswordApi());

final changePasswordRepoProvider =
    Provider<ChangePasswordRepository>((ref) => ChangePasswordRepository(ref.read(changePasswordApiProvider)));

final changePasswordDataProvider = StateNotifierProvider<ChangePasswordDataNotifier, ChangePasswordState>(
    (ref) => ChangePasswordDataNotifier(ref.read(changePasswordRepoProvider), ref.read(routerProvider)));

class ChangePasswordDataNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordDataNotifier(this.changePasswordRepository, this.router) : super(const ChangePasswordState()) {
    usernameController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    newPasswordController = TextEditingController(text: "");
    newPasswordAgainController = TextEditingController(text: "");

    usernameController.addListener(_updateState);
    passwordController.addListener(_updateState);
    newPasswordController.addListener(_updateState);
    newPasswordAgainController.addListener(_updateState);
  }

  final ChangePasswordRepository changePasswordRepository;
  final GoRouter router;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController newPasswordAgainController;

  Future<void> changePassword() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      if (state.newPassword != state.newPasswordAgain) {
        clear(false, false);
        state = state.copyWith(modelState: ModelState.error, message: "Passwords do not match");
      } else {
        await changePasswordRepository.changePassword(
            state.username, Utils.encrypt(state.password), Utils.encrypt(state.newPassword));
        clear(true, true);
      }
    } on DioException catch (e) {
      state = state.copyWith(
          username: "",
          password: "",
          newPassword: "",
          newPasswordAgain: "",
          modelState: ModelState.error,
          message: e.response?.data ?? e.message);
    }
  }

  void _updateState() {
    state = state.copyWith(
      username: usernameController.value.text,
      password: passwordController.value.text,
      newPassword: newPasswordController.value.text,
      newPasswordAgain: newPasswordAgainController.value.text,
    );
  }

  void clear(bool success, bool shouldPop) {
    usernameController.clear();
    passwordController.clear();
    newPasswordController.clear();
    newPasswordAgainController.clear();
    state =
        state.copyWith(username: "", password: "", newPassword: "", newPasswordAgain: "", modelState: ModelState.empty);
    if (shouldPop && router.canPop()) {
      router.pop(success);
    }
  }
}
