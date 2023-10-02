import 'package:freezed_annotation/freezed_annotation.dart';

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
    required num roundNumber
}) = _RoundModel;

  factory RoundModel.fromJson(Map<String, dynamic> json) => _$RoundModelFromJson(json);
}