import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/notifications/data/api/notification_api.dart';
import 'package:work_hu/features/notifications/data/model/notification_preference_model.dart';

class NotificationRepository {
  NotificationRepository(this._api);

  final NotificationApi _api;

  Future<NotificationTestResult> sendTest() =>
      guardApi(() async => NotificationTestResult.fromJson(await _api.sendTest() as Map<String, dynamic>));

  Future<List<NotificationPreferenceModel>> getPreferences() => guardApi(() async {
    final res = await _api.getPreferences();
    return (res as List).map((e) => NotificationPreferenceModel.fromJson(e as Map<String, dynamic>)).toList();
  });

  /// Sends only the changed setting; the backend answers with the full list.
  Future<List<NotificationPreferenceModel>> setEnabled(String type, bool enabled) => guardApi(() async {
    final res = await _api.putPreferences({type: enabled});
    return (res as List).map((e) => NotificationPreferenceModel.fromJson(e as Map<String, dynamic>)).toList();
  });
}

/// What the backend did with a test notification: how many of the user's devices it tried and how many accepted it.
class NotificationTestResult {
  const NotificationTestResult({required this.devices, required this.delivered, required this.failed});

  final int devices;
  final int delivered;
  final int failed;

  factory NotificationTestResult.fromJson(Map<String, dynamic> json) => NotificationTestResult(
    devices: (json['devices'] as num?)?.toInt() ?? 0,
    delivered: (json['delivered'] as num?)?.toInt() ?? 0,
    failed: (json['failed'] as num?)?.toInt() ?? 0,
  );
}
