import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

part 'team_round_model.freezed.dart';
part 'team_round_model.g.dart';

@freezed
class TeamRoundModel with _$TeamRoundModel{
  const factory TeamRoundModel({
    required num id,
    required RoundModel round,
    required TeamModel team,
    required double teamPoints,
    required double samvirkPayments
  }) = _TeamRoundModel;

  factory TeamRoundModel.fromJson(Map<String, dynamic> json) => _$TeamRoundModelFromJson(json);
}