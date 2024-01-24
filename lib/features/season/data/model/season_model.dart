import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_model.freezed.dart';
part 'season_model.g.dart';

@freezed
class SeasonModel with _$SeasonModel {
  const factory SeasonModel({
    required num id,
    required num seasonYear,
    required DateTime startDate,
    required DateTime endDate,
  }) = _SeasonModel;

  factory SeasonModel.fromJson(Map<String, dynamic> json) => _$SeasonModelFromJson(json);
}