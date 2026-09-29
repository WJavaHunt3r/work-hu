import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/change_password/data/api/change_password_api.dart';
import 'package:work_hu/features/change_password/data/repository/change_password_repository.dart';
import 'package:work_hu/features/change_password/data/state/change_password_state.dart';
import 'package:work_hu/features/utils.dart';

final changePasswordApiProvider = Provider<ChangePasswordApi>((ref) => ChangePasswordApi());

final changePasswordRepoProvider = Provider<ChangePasswordRepository>(
  (ref) => ChangePasswordRepository(ref.read(changePasswordApiProvider)),
);

final changePasswordDataProvider = StateNotifierProvider<ChangePasswordDataNotifier, ChangePasswordState>(
  (ref) => ChangePasswordDataNotifier(ref.read(changePasswordRepoProvider)),
);

class ChangePasswordDataNotifier extends BaseDataNotifier<ChangePasswordState> {
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

  /// Returns whether the password was changed.
  Future<bool> changePassword() async {
    if (state.newPassword != state.newPasswordAgain) {
      clear();
      state = copyWithState(const BaseState(modelState: ModelState.error, message: "login_password_not_match"));
      return false;
    }
    var usr = await Utils.getData('user');
    var pswd = await Utils.getData('password');
    var newPassword = state.newPassword;
    var result = await executeApiCall<String>(
      () => changePasswordRepository.changePassword(usr, pswd, newPassword),
      onSuccess: (_) async {
        await Utils.saveData('password', newPassword);
        userProvider.setUser(userProvider.user!.copyWith(changedPassword: true));
        clear();
      },
    );
    return result != null;
  }

  void _updateState() {
    state = state.copyWith(
      newPassword: newPasswordController.value.text,
      newPasswordAgain: newPasswordAgainController.value.text,
    );
  }

  void setUsername(String username, String password) {
    state = state.copyWith(username: username, password: password);
  }

  void clear() {
    newPasswordController.clear();
    newPasswordAgainController.clear();
    state = state.copyWith(newPassword: "", newPasswordAgain: "");
  }

  @override
  ChangePasswordState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }
}
