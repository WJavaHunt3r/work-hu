import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';

part 'round_model.freezed.dart';
part 'round_model.g.dart';

@freezed
class RoundModel with _$RoundModel{
  const factory RoundModel({
    required num id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required num myShareGoal,
    required num samvirkGoal,
    required num samvirkChurchGoal,
    required num roundNumber,
    required SeasonModel season
}) = _RoundModel;

  factory RoundModel.fromJson(Map<String, dynamic> json) => _$RoundModelFromJson(json);
}