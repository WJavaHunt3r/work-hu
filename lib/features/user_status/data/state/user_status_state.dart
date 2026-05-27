import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/features/user_status/data/model/user_status_filter.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';

part 'user_status_state.freezed.dart';

@freezed
abstract class UserStatusState with _$UserStatusState {
  const factory UserStatusState(
      {@Default([]) List<UserStatusModel> userStatuses,
      @Default(UserStatusFilter()) UserStatusFilter filter,
        @Default(0) int onTrackCount,
      @Default(BaseListState()) BaseListState status}) = _UserStatusState;

  const UserStatusState._();
}
