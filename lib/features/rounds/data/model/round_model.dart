import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

part 'round_model.freezed.dart';
part 'round_model.g.dart';

@freezed
abstract class RoundModel with _$RoundModel {
  const factory RoundModel({
    required num id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required num myShareGoal,
    // Old rounds can have empty columns here: they must not make the whole list unreadable
    @Default(0) num samvirkGoal,
    @Default(0) num samvirkChurchGoal,
    required num roundNumber,
    required SeasonModel season,
    DateTime? freezeDateTime,
    @Default(true) bool activeRound,
    TeamModel? winnerTeam,
    required num localMyShareGoal,

    /// The Samvirk church status (a percentage towards the common goal); empty on old rounds.
    num? samvirkChurchStatus,
  }) = _RoundModel;

  /// Old rounds can have no local goal: it is then the same as the main goal.
  factory RoundModel.fromJson(Map<String, dynamic> json) =>
      _$RoundModelFromJson({...json, 'localMyShareGoal': json['localMyShareGoal'] ?? json['myShareGoal']});
}
