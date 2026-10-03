import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_schedule_model.freezed.dart';
part 'notification_schedule_model.g.dart';

/// A weekly schedule: either a recurring push (`WEEKLY`, with title, body and target roles) or the schedule of the
/// "on track" e-mail (`ON_TRACK_EMAIL`, only day, time and active can be changed).
@freezed
abstract class NotificationScheduleModel with _$NotificationScheduleModel {
  const factory NotificationScheduleModel({
    num? id,
    @Default('WEEKLY') String type,
    String? title,
    String? body,

    /// `MONDAY` ... `SUNDAY`.
    @Default('MONDAY') String dayOfWeek,

    /// `HH:mm` (the backend may add seconds), server time.
    @Default('17:00') String time,
    @Default(true) bool active,
    @Default([]) List<num> roleIds,
    DateTime? lastSentDateTime,
  }) = _NotificationScheduleModel;

  factory NotificationScheduleModel.fromJson(Map<String, dynamic> json) => _$NotificationScheduleModelFromJson(json);

  const NotificationScheduleModel._();

  bool get isEmail => type == 'ON_TRACK_EMAIL';

  /// `time` without seconds.
  String get shortTime => time.length >= 5 ? time.substring(0, 5) : time;

  /// The body the backend expects: `HH:mm`, and no push fields for the e-mail schedule.
  Map<String, dynamic> toRequest() => {...toJson(), 'time': shortTime};
}
