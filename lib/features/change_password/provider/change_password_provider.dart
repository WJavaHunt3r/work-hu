import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/change_password/data/api/change_password_api.dart';
import 'package:work_hu/features/change_password/data/repository/change_password_repository.dart';
import 'package:work_hu/features/change_password/data/state/change_password_state.dart';
import 'package:work_hu/features/utils.dart';

final changePasswordApiProvider = Provider<ChangePasswordApi>((ref) => ChangePasswordApi());

final changePasswordRepoProvider =
    Provider<ChangePasswordRepository>((ref) => ChangePasswordRepository(ref.read(changePasswordApiProvider)));

final changePasswordDataProvider = StateNotifierProvider<ChangePasswordDataNotifier, ChangePasswordState>(
    (ref) => ChangePasswordDataNotifier(ref.read(changePasswordRepoProvider)));

class ChangePasswordDataNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordDataNotifier(this.changePasswordRepository) : super(const ChangePasswordState()) {
    // usernameController = TextEditingController(text: "");
    // passwordController = TextEditingController(text: "");
    newPasswordController = TextEditingController(text: "");
    newPasswordAgainController = TextEditingController(text: "");

    // usernameController.addListener(_updateState);
    // passwordController.addListener(_updateState);
    newPasswordController.addListener(_updateState);
    newPasswordAgainController.addListener(_updateState);
  }

  final ChangePasswordRepository changePasswordRepository;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController newPasswordAgainController;

  Future<void> changePassword() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      if (state.newPassword != state.newPasswordAgain) {
        clear(false, false);
        state = state.copyWith(modelState: ModelState.error, message: "A jelszavak nem egyeznek");
      } else {
        await changePasswordRepository.changePassword(
            state.username, Utils.encrypt(state.password), Utils.encrypt(state.newPassword));
        clear(true, true);
      }
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.response?.data ?? e.message);
    }
  }

  void _updateState() {
    state = state.copyWith(
      newPassword: newPasswordController.value.text,
      newPasswordAgain: newPasswordAgainController.value.text,
    );
  }

  void setUsername(String username, String password) {
    // usernameController.text = username;
    state = state.copyWith(username: username, password: password);
  }

  void clear(bool success, bool shouldPop) {
    // usernameController.clear();
    // passwordController.clear();
    newPasswordController.clear();
    newPasswordAgainController.clear();
    state = state.copyWith(newPassword: "", newPasswordAgain: "", modelState: ModelState.success);
  }
}
