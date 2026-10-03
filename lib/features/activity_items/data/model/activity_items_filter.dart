import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_items_filter.freezed.dart';
part 'activity_items_filter.g.dart';

@freezed
abstract class ActivityItemsFilter with _$ActivityItemsFilter {
  const factory ActivityItemsFilter({
    num? activityId,
    num? userId,
    num? roundId,
    bool? registeredInApp,
    String? searchText,
  }) = _ActivityItemsFilter;

  factory ActivityItemsFilter.fromJson(Map<String, dynamic> json) => _$ActivityItemsFilterFromJson(json);
}
