import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/notification_admin/data/model/notification_schedule_model.dart';
import 'package:work_hu/features/notification_admin/providers/notification_admin_provider.dart';
import 'package:work_hu/features/roles/providers/roles_provider.dart' show NoFilter;

/// The weekly push notifications and the schedule of the "on track" e-mail.
class NotificationSchedulesPage extends BaseListPage {
  const NotificationSchedulesPage({super.key, super.title = "notification_admin_schedules_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NotificationSchedulesPageState();
}

class NotificationSchedulesPageState
    extends
        PagedListPageState<
          NotificationSchedulesPage,
          NotificationScheduleModel,
          NoFilter,
          NotificationSchedulesNotifier
        > {
  @override
  get provider => notificationSchedulesProvider;

  @override
  Widget buildListTile(NotificationScheduleModel item, int index) {
    return BaseListTile(
      index: index,
      isLast: index == items.length - 1,
      title: Text(
        item.isEmail ? "notification_type_ON_TRACK_EMAIL".i18n() : item.title ?? "",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "${"weekday_${item.dayOfWeek}".i18n()} ${item.shortTime}",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Switch.adaptive(value: item.active, onChanged: (on) => notifier.setActive(item, on)),
      onTap: () => _edit(item),
    );
  }

  /// The e-mail schedule can only be switched off, not deleted.
  @override
  bool canDelete(NotificationScheduleModel item) => !item.isEmail;

  @override
  void onDelete(NotificationScheduleModel item) => notifier.deleteSchedule(item.id!);

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) =>
      FloatingActionButton(onPressed: () => _edit(null), child: const Icon(Icons.add));

  void _edit(NotificationScheduleModel? schedule) => context
      .push("/admin/notifications/schedules/edit", extra: schedule)
      .then((saved) => saved == true ? notifier.reload() : null);
}
