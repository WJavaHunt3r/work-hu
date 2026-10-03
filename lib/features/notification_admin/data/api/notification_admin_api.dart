import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/notification_admin/data/model/general_notification_model.dart';
import 'package:work_hu/features/notification_admin/data/model/notification_schedule_model.dart';

class NotificationAdminApi {
  final DioClient _dioClient = locator<DioClient>();

  Future<dynamic> getGeneral(ListQuery<Object?> query, int page) async =>
      (await _dioClient.dio.get("/notifications/general", queryParameters: query.pageParams(page))).data;

  /// Sends at once; returns the stored notification with delivery counts.
  Future<dynamic> sendGeneral(GeneralNotificationModel notification) async =>
      (await _dioClient.dio.post("/notifications/general", data: notification.toJson())).data;

  Future<List<dynamic>> getSchedules() async => (await _dioClient.dio.get("/notifications/schedules")).data;

  Future<dynamic> postSchedule(NotificationScheduleModel schedule) async =>
      (await _dioClient.dio.post("/notifications/schedules", data: schedule.toRequest())).data;

  Future<dynamic> putSchedule(NotificationScheduleModel schedule) async =>
      (await _dioClient.dio.put("/notifications/schedules/${schedule.id}", data: schedule.toRequest())).data;

  Future<dynamic> deleteSchedule(num id) async => (await _dioClient.dio.delete("/notifications/schedules/$id")).data;
}
