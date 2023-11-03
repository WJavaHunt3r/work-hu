import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

part 'team_state.freezed.dart';

@freezed
abstract class TeamState with _$TeamState {
  const factory TeamState({
    @Default([]) List<TeamModel> teams,
    @Default(ModelState.empty) ModelState modelState,
}) = _TeamState;

  const TeamState._();
}