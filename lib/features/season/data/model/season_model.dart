import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_model.freezed.dart';
part 'season_model.g.dart';

@freezed
abstract class SeasonModel with _$SeasonModel {
  const factory SeasonModel({
    required num id,
    required num seasonYear,
    // Old seasons can have no dates
    DateTime? startDate,
    DateTime? endDate,
  }) = _SeasonModel;

  factory SeasonModel.fromJson(Map<String, dynamic> json) => _$SeasonModelFromJson(json);
}
