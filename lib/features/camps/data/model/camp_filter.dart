import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';

part 'camp_filter.freezed.dart';

part 'camp_filter.g.dart';

@freezed
class CampFilter with _$CampFilter {
  const factory CampFilter({
    int? seasonYear,
  }) = _CampFilter;

  factory CampFilter.fromJson(Map<String, dynamic> json) => _$CampFilterFromJson(json);
}
