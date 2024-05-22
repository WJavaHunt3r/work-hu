import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState(
      {@Default("") String username,
      @Default("") String password,
      @Default(ModelState.empty) ModelState modelState,
        @Default(ModelState.empty) ModelState resetState,
      @Default("") String message}) = _LoginState;

  const LoginState._();
}
