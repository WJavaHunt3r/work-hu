import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/user_fra_kare_week/data/model/user_fra_kare_week_model.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default([]) List<UserRoundModel> userRounds,
    @Default([]) List<UserModel> children,
    @Default([]) List<GoalModel> childrenGoals,
    @Default([]) List<num> roundPoints,
    @Default([]) List<UserRoundModel> childrenUserRounds,
    @Default([]) List<UserFraKareWeekModel> fraKareWeeks,
    GoalModel? userGoal,
    UserModel? spouse,
    @Default(ModelState.empty) ModelState modelState,
  }) = _ProfileState;

  const ProfileState._();
}