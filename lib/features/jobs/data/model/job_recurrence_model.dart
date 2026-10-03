import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/utils.dart';

part 'job_recurrence_model.freezed.dart';
part 'job_recurrence_model.g.dart';

String _dateOnly(DateTime date) => Utils.dateToString(date);

/// Makes a new job repeat: one job per date from the job's own date up to [repeatUntil] (inclusive) whose weekday is
/// in [daysOfWeek] (`MONDAY` ... `SUNDAY`). Only sent when creating; the backend creates the separate jobs.
@freezed
abstract class JobRecurrenceModel with _$JobRecurrenceModel {
  const factory JobRecurrenceModel({
    @Default([]) List<String> daysOfWeek,
    @JsonKey(toJson: _dateOnly) required DateTime repeatUntil,
  }) = _JobRecurrenceModel;

  factory JobRecurrenceModel.fromJson(Map<String, dynamic> json) => _$JobRecurrenceModelFromJson(json);
}
