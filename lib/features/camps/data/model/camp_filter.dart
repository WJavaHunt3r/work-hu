import 'package:freezed_annotation/freezed_annotation.dart';

part 'camp_filter.freezed.dart';
part 'camp_filter.g.dart';

@freezed
abstract class CampFilter with _$CampFilter {
  const factory CampFilter({int? seasonYear}) = _CampFilter;

  factory CampFilter.fromJson(Map<String, dynamic> json) => _$CampFilterFromJson(json);
}
