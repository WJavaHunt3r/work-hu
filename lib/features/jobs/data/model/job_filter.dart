import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';

part 'job_filter.freezed.dart';
part 'job_filter.g.dart';

@freezed
abstract class JobFilter with _$JobFilter {
  const factory JobFilter({
    JobStatus? status,

    /// Only jobs that accept registrations right now.
    @Default(false) bool openOnly,

    /// Only jobs the current user is registered for.
    @Default(false) bool onlyMine,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? searchText,
  }) = _JobFilter;

  factory JobFilter.fromJson(Map<String, dynamic> json) => _$JobFilterFromJson(json);
}
