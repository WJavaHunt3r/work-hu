import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';

part 'team_round_state.freezed.dart';

@freezed
abstract class TeamRoundState with _$TeamRoundState {
  const factory TeamRoundState({
    @Default([]) List<TeamRoundModel> teams,
    @Default([]) List<UserRoundModel> users,
    @Default(ModelState.empty) ModelState modelState,
}) = _TeamRoundState;

  const TeamRoundState._();
}