import 'package:freezed_annotation/freezed_annotation.dart';

part 'general_notification_model.freezed.dart';
part 'general_notification_model.g.dart';

/// A one-off push notification sent by an admin. Delivery counts are filled in by the backend after sending.
@freezed
abstract class GeneralNotificationModel with _$GeneralNotificationModel {
  const factory GeneralNotificationModel({
    num? id,
    required String title,
    required String body,

    /// Target roles; empty = all users.
    @Default([]) List<num> roleIds,
    String? sentByName,
    DateTime? sentDateTime,
    @Default(0) int recipientUsers,
    @Default(0) int delivered,
    @Default(0) int failed,
  }) = _GeneralNotificationModel;

  factory GeneralNotificationModel.fromJson(Map<String, dynamic> json) => _$GeneralNotificationModelFromJson(json);
}
