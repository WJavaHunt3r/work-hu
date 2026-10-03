import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_header_chip.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_filter.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/activity_items/provider/activity_items_provider.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/framework/base_components/base_page_components/base_list_page.dart';

class ActivityItemsPage extends BaseListPage {
  const ActivityItemsPage({required this.activityId, super.key, super.title = "activity_items_registrations"});

  final num activityId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ActivityItemsPageState();
  }
}

class ActivityItemsPageState
    extends PagedListPageState<ActivityItemsPage, ActivityItemsModel, ActivityItemsFilter, ActivityItemsDataNotifier> {
  @override
  get provider => activityItemsDataProvider(widget.activityId);

  /// Loads in parallel with the items, so it can still be null while they show.
  ActivityModel? get activity => ref.watch(activityDetailProvider(widget.activityId)).activity;

  @override
  Widget build(BuildContext context) {
    // The base page only reports errors of the list provider.
    ref.listen(activityDetailProvider(widget.activityId), (previous, next) {
      if (next.status.modelState.isError && !(previous?.status.modelState.isError ?? false)) {
        Utils.showErrorDialog(context, content: next.status.message.i18n());
      }
    });
    return super.build(context);
  }

  @override
  Widget buildListTile(ActivityItemsModel item, int index) {
    final date = activity?.activityDateTime;
    return BaseListTile(
      onTap: () {},
      trailing: Text(
        "${item.hours.toString()} ${Utils.getTransactionTypeText(TransactionType.HOURS, false)}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
      ),
      title: Row(
        children: [Text(item.userName, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
      subtitle: Text(date == null ? "" : Utils.dateToString(date)),
      isLast: index == items.length - 1,
      index: index,
    );
  }

  @override
  void onDelete(ActivityItemsModel item) => notifier.deleteActivityItem(item.id!);

  @override
  bool canDelete(ActivityItemsModel item) {
    final activity = this.activity;
    return activity != null && !activity.registeredInApp && !activity.registeredInMyShare;
  }

  @override
  List<Widget>? buildActions(BuildContext context, WidgetRef ref) {
    return activity != null && !activity!.registeredInApp
        ? [
            IconButton(
              onPressed: () async {
                await ref.read(activityDetailProvider(widget.activityId).notifier).registerActivity(items);
                if (mounted) Navigator.of(this.context).pop(true);
              },
              icon: const Icon(Icons.send_outlined),
            ),
          ]
        : null;
  }

  @override
  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) {
    var activity = this.activity;
    return [
      BaseHeaderChip(
        label: "activity_items_date",
        labelValue: () async =>
            activity == null ? "" : "${activity.description} - ${Utils.dateFormating(activity.createDateTime)}",
      ),
      BaseHeaderChip(label: "activity_items_employer", labelValue: () async => activity?.employerName ?? ""),
      BaseHeaderChip(label: "activity_items_responsible", labelValue: () async => activity?.responsibleName ?? ""),
      BaseHeaderChip(
        label: "activity_items_transactionType",
        labelValue: () async => activity?.transactionType.name ?? "",
      ),
      if (ref.read(userDataProvider).user!.isAdmin())
        BaseHeaderChip(label: "activity_items_created_by", labelValue: () async => activity?.createUserName ?? ""),
    ];
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: activity == null
          ? null
          : () => ref.read(activityDetailProvider(widget.activityId).notifier).createCreditCsv(items),
      child: const Image(image: AssetImage("assets/img/myshare-logo.png"), fit: BoxFit.fitWidth),
    );
  }
}
