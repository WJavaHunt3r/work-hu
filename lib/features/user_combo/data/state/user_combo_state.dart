import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/user_combo/data/model/user_filter.dart';

part 'user_combo_state.freezed.dart';

@freezed
abstract class UserComboState with _$UserComboState {
  const factory UserComboState({
    @Default(UserFilter(churchId: 1)) UserFilter filter,
    @Default(BaseState()) BaseState status,
  }) = _UserComboState;

  const UserComboState._();
}
