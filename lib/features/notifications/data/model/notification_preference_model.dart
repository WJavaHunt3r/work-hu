import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preference_model.freezed.dart';
part 'notification_preference_model.g.dart';

/// One notification type (with its delivery [channel], `PUSH` or `EMAIL`) the user can switch on or off. [type] is the backend's name (e.g. `JOB_REMINDER`) and is
/// translated with `notification_type_<TYPE>`; unknown types show their raw name.
@freezed
abstract class NotificationPreferenceModel with _$NotificationPreferenceModel {
  const factory NotificationPreferenceModel({required String type, String? channel, @Default(true) bool enabled}) =
      _NotificationPreferenceModel;

  factory NotificationPreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferenceModelFromJson(json);
}
