import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';

part 'camp_model.freezed.dart';

part 'camp_model.g.dart';

@freezed
class CampModel with _$CampModel {
  const factory CampModel({
    num? id,
    required SeasonModel seasonModel,
    required DateTime campDate,
    required DateTime financeCheckDate,
    required num u18BrunstadFee,
    required num u18LocalFee,
    required num o18BrunstadFee,
    required num o18LocalFee,
  }) = _CampModel;

  factory CampModel.fromJson(Map<String, dynamic> json) => _$CampModelFromJson(json);
}
