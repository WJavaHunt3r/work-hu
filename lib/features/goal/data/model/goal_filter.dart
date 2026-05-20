import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_filter.freezed.dart';

part 'goal_filter.g.dart';

@freezed
class GoalFilter with _$GoalFilter {
  const factory GoalFilter({int? seasonYear, int? userId}) = _GoalFilter;

  factory GoalFilter.fromJson(Map<String, dynamic> json) => _$GoalFilterFromJson(json);
}
