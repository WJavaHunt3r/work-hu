import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/notification_admin/data/api/notification_admin_api.dart';
import 'package:work_hu/features/notification_admin/data/model/general_notification_model.dart';
import 'package:work_hu/features/notification_admin/data/model/notification_schedule_model.dart';
import 'package:work_hu/features/notification_admin/data/model/overdue_jobs_model.dart';

class NotificationAdminRepository {
  NotificationAdminRepository(this._api);

  final NotificationAdminApi _api;

  Future<PaginatedResponse<GeneralNotificationModel>> getGeneral(ListQuery<Object?> query, {int page = 0}) =>
      guardApi(() async {
        final res = await _api.getGeneral(query, page);
        return PaginatedResponse<GeneralNotificationModel>.fromJson(
          res,
          (json) => GeneralNotificationModel.fromJson(json as Map<String, dynamic>),
        );
      });

  Future<GeneralNotificationModel> sendGeneral(GeneralNotificationModel notification) =>
      guardApi(() async => GeneralNotificationModel.fromJson(await _api.sendGeneral(notification)));

  Future<List<OverdueJobsModel>> getOverdueJobs() => guardApi(() async {
    final res = await _api.getOverdueJobs();
    return res.map((e) => OverdueJobsModel.fromJson(e as Map<String, dynamic>)).toList();
  });

  /// Returns how many users the reminder reached.
  Future<num> remindOverdue(List<num> userIds) =>
      guardApi(() async => ((await _api.remindOverdue(userIds)) as Map<String, dynamic>)['users'] as num);

  /// Not paged by the backend, so everything comes back as one page.
  Future<PaginatedResponse<NotificationScheduleModel>> getSchedules() => guardApi(() async {
    final res = await _api.getSchedules();
    return PaginatedResponse.all(
      res.map((e) => NotificationScheduleModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  });

  Future<NotificationScheduleModel> saveSchedule(NotificationScheduleModel schedule) => guardApi(
    () async => NotificationScheduleModel.fromJson(
      schedule.id == null ? await _api.postSchedule(schedule) : await _api.putSchedule(schedule),
    ),
  );

  Future<void> deleteSchedule(num id) => guardApi(() => _api.deleteSchedule(id));
}
