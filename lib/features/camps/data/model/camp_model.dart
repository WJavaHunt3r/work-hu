import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';

part 'camp_model.freezed.dart';

part 'camp_model.g.dart';

@freezed
class CampModel with _$CampModel {
  const factory CampModel({
    num? id,
    SeasonModel? season,
    String? campName,
    DateTime? campDate,
    DateTime? financeCheckDate,
    num? u18BrunstadFee,
    num? u18LocalFee,
    num? o18BrunstadFee,
    num? o18LocalFee,
  }) = _CampModel;

  factory CampModel.fromJson(Map<String, dynamic> json) => _$CampModelFromJson(json);
}
