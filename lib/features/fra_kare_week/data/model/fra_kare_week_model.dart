import 'package:freezed_annotation/freezed_annotation.dart';

part 'fra_kare_week_model.freezed.dart';

part 'fra_kare_week_model.g.dart';

@freezed
class FraKareWeekModel with _$FraKareWeekModel {
  const factory FraKareWeekModel(
      {num? id,
      required num weekNumber,
      required bool activeWeek,
      required num year,
      required DateTime weekStartDate,
      required DateTime weekEndDate,
      required bool locked}) = _FraKareWeekModel;

  factory FraKareWeekModel.fromJson(Map<String, dynamic> json) => _$FraKareWeekModelFromJson(json);
}
