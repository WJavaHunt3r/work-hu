import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';

part 'change_password_state.freezed.dart';

@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default("") String username,
    @Default("") String password,
    @Default("") String newPassword,
    @Default("") String newPasswordAgain,
    @Default(BaseState()) BaseState status,
  }) = _ChangePasswordState;

  const ChangePasswordState._();
}
