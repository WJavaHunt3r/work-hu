import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_filter.dart';

part 'users_state.freezed.dart';

@freezed
abstract class UsersState with _$UsersState {
  const factory UsersState(
      {@Default([]) List<UserComboModel> users,
      UserModel? selectedUser,
      @Default(UserFilter(churchId: 1)) UserFilter filter,
      @Default(BaseListState()) BaseListState listState,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _UsersState;

  const UsersState._();
}
