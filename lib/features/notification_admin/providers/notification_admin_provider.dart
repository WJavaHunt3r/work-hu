import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/notification_admin/data/api/notification_admin_api.dart';
import 'package:work_hu/features/notification_admin/data/model/general_notification_model.dart';
import 'package:work_hu/features/notification_admin/data/model/notification_schedule_model.dart';
import 'package:work_hu/features/notification_admin/data/repository/notification_admin_repository.dart';
import 'package:work_hu/features/roles/providers/roles_provider.dart' show NoFilter;

final notificationAdminRepoProvider = Provider<NotificationAdminRepository>(
  (ref) => NotificationAdminRepository(NotificationAdminApi()),
);

final generalNotificationsProvider =
    StateNotifierProvider.autoDispose<GeneralNotificationsNotifier, PagedState<GeneralNotificationModel, NoFilter>>(
      (ref) => GeneralNotificationsNotifier(ref.read(notificationAdminRepoProvider)),
    );

class GeneralNotificationsNotifier extends PagedListNotifier<GeneralNotificationModel, NoFilter> {
  GeneralNotificationsNotifier(this.repository) : super(const ListQuery(filter: NoFilter()));

  final NotificationAdminRepository repository;

  @override
  Future<PaginatedResponse<GeneralNotificationModel>> fetch(ListQuery<NoFilter> query, int page) =>
      repository.getGeneral(query, page: page);
}

final notificationSchedulesProvider =
    StateNotifierProvider.autoDispose<NotificationSchedulesNotifier, PagedState<NotificationScheduleModel, NoFilter>>(
      (ref) => NotificationSchedulesNotifier(ref.read(notificationAdminRepoProvider)),
    );

class NotificationSchedulesNotifier extends PagedListNotifier<NotificationScheduleModel, NoFilter> {
  NotificationSchedulesNotifier(this.repository) : super(const ListQuery(filter: NoFilter()));

  final NotificationAdminRepository repository;

  @override
  Future<PaginatedResponse<NotificationScheduleModel>> fetch(ListQuery<NoFilter> query, int page) =>
      repository.getSchedules();

  Future<void> deleteSchedule(num id) async {
    await executeApiCall(
      () => repository.deleteSchedule(id),
      onSuccess: (_) async => removeItems((s) => s.id == id),
      onError: (message) async => showApiError(message),
    );
  }

  /// Flips the active flag from the list.
  Future<void> setActive(NotificationScheduleModel schedule, bool active) async {
    try {
      final saved = await repository.saveSchedule(schedule.copyWith(active: active));
      updateItems((items) => [for (final s in items) s.id == saved.id ? saved : s]);
    } on ApiException catch (e) {
      showApiError(e.message);
    }
  }
}
