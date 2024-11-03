import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';

part 'user_status_state.freezed.dart';

@freezed
abstract class UserStatusState with _$UserStatusState {
  const factory UserStatusState(
      {@Default([]) List<GoalModel> goals,
      @Default([]) List<UserRoundModel> userRounds,
      @Default(0) num selectedTeamId,
      @Default(OrderByType.NAME) OrderByType selectedOrderType,
      RoundModel? currentRound,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _UserStatusState;

  const UserStatusState._();
}
