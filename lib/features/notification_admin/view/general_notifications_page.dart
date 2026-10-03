import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/notification_admin/data/model/general_notification_model.dart';
import 'package:work_hu/features/notification_admin/providers/notification_admin_provider.dart';
import 'package:work_hu/features/roles/providers/roles_provider.dart' show NoFilter;
import 'package:work_hu/features/utils.dart';

/// Notifications sent so far (newest first) with their delivery result; the button composes a new one.
class GeneralNotificationsPage extends BaseListPage {
  const GeneralNotificationsPage({super.key, super.title = "notification_admin_send_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => GeneralNotificationsPageState();
}

class GeneralNotificationsPageState
    extends
        PagedListPageState<GeneralNotificationsPage, GeneralNotificationModel, NoFilter, GeneralNotificationsNotifier> {
  @override
  get provider => generalNotificationsProvider;

  @override
  Widget buildListTile(GeneralNotificationModel item, int index) {
    return BaseListTile(
      index: index,
      isLast: index == items.length - 1,
      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        "${item.body}\n${Utils.dateFormatingWithTime(item.sentDateTime)}"
        "${item.sentByName == null ? "" : " · ${item.sentByName}"}\n"
        "${"notification_admin_result".i18n(["${item.delivered}", "${item.recipientUsers}", "${item.failed}"])}",
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) => FloatingActionButton(
    onPressed: () => context.push("/admin/notifications/send").then((sent) => sent == true ? notifier.reload() : null),
    child: const Icon(Icons.send),
  );
}
