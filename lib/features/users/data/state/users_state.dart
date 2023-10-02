import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'users_state.freezed.dart';

@freezed
abstract class UsersState with _$UsersState{
  const factory UsersState({
    @Default([]) List<UserModel> users,
    @Default(ModelState.empty) ModelState modelState,
    @Default("") String message
}) = _UsersState;

  const UsersState._();

}