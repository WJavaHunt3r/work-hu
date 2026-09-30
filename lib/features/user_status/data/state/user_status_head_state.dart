import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/user_rounds/data/model/user_round_head_model.dart';

part 'user_status_head_state.freezed.dart';

@freezed
abstract class UserStatusHeadState with _$UserStatusHeadState {
  const factory UserStatusHeadState({
    @Default(UserRoundHeadModel(onTrackCount: 0, goalCount: 0, churchGoal: 0, toOnTrackCount: 0, localMyShareGoal: 0))
    UserRoundHeadModel headData,
    @Default(BaseState()) BaseState status,
  }) = _UserStatusHeadState;
}
