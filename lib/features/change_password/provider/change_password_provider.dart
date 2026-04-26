import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
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
    newPasswordController = TextEditingController(text: "");
    newPasswordAgainController = TextEditingController(text: "");

    newPasswordController.addListener(_updateState);
    newPasswordAgainController.addListener(_updateState);
  }

  final ChangePasswordRepository changePasswordRepository;
  late final TextEditingController newPasswordController;
  late final TextEditingController newPasswordAgainController;
  final UserProvider userProvider = locator<UserProvider>();

  Future<void> changePassword() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      if (state.newPassword != state.newPasswordAgain) {
        clear(false, false);
        state = state.copyWith(modelState: ModelState.error, message: "A jelszavak nem egyeznek!");
      } else {
        var usr = await Utils.getData('user');
        var pswd = await Utils.getData('password');
        await changePasswordRepository.changePassword(usr, pswd, state.newPassword).then((e) async {
          await Utils.saveData('password', state.newPassword);
          userProvider.setUser(userProvider.user!.copyWith(changedPassword: true));
        });
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
    newPasswordController.clear();
    newPasswordAgainController.clear();
    state = state.copyWith(newPassword: "", newPasswordAgain: "", modelState: ModelState.success);
  }
}
