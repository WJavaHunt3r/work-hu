import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

part 'team_round_state.freezed.dart';

@freezed
abstract class TeamRoundState with _$TeamRoundState {
  const factory TeamRoundState({
    @Default([]) List<TeamModel> teams,
    @Default([]) List<TeamRoundModel> teamRounds,
    @Default([]) List<DonationModel> donations,
    @Default(ModelState.empty) ModelState modelState,
    @Default("") String message,
}) = _TeamRoundState;

  const TeamRoundState._();
}