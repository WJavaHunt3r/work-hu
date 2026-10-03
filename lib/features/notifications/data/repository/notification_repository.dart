import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/notifications/data/api/notification_api.dart';
import 'package:work_hu/features/notifications/data/model/notification_preference_model.dart';

class NotificationRepository {
  NotificationRepository(this._api);

  final NotificationApi _api;

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
