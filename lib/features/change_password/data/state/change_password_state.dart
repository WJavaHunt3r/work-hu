import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';

part 'change_password_state.freezed.dart';

@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState(
      {@Default("") String username,
        @Default("") String password,
      @Default("") String newPassword,
        @Default("") String newPasswordAgain,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _ChangePasswordState;

  const ChangePasswordState._();
}
