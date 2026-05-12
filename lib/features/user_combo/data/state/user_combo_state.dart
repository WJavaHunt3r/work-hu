import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/features/user_combo/data/model/user_filter.dart';

import '../model/user_combo_model.dart';

part 'user_combo_state.freezed.dart';

@freezed
abstract class UserComboState with _$UserComboState {
  const factory UserComboState(
      {
        @Default(UserFilter(churchId: 1)) UserFilter filter,
        @Default(BaseListState()) BaseListState status}) = _UserComboState;

  const UserComboState._();
}
