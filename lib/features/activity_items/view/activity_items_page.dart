import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_header_chip.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/activity_items/data/state/activity_items_state.dart';
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

class ActivityItemsPageState extends BaseListPageState<ActivityItemsPage, ActivityItemsState, ActivityItemsDataNotifier> {
  @override
  void postInit(WidgetRef ref) {
    ref.read(provider.notifier).getActivity(widget.activityId);
  }

  @override
  Widget buildListTile(item) {
    var date = state.activity!.activityDateTime;
    var dateString = Utils.dateToString(date);
    return BaseListTile(
      onTap: () {},
      trailing: Text(
        "${item.hours.toString()} ${Utils.getTransactionTypeText(TransactionType.HOURS, false)}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
      ),
      title: Row(
        children: [
          Text(item.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      subtitle: Text(dateString),
      isLast: items.indexOf(item) == items.length - 1,
      index: items.indexOf(item),
    );
  }

  @override
  onDelete(e) {
    e as ActivityItemsModel;
    ref.watch(provider.notifier).deleteActivityItem(e.id!);
  }

  @override
  bool canDelete(item) {
    var activity = state.activity;
    return !activity!.registeredInApp && !activity.registeredInMyShare;
  }

  @override
  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) {
    var activity = state.activity;
    return [
      BaseHeaderChip(
        label: "activity_items_date",
        labelValue: () async => " ${activity?.description}  - ${Utils.dateFormating(activity?.createDateTime)} ",
      ),
      BaseHeaderChip(label: "activity_items_employer", labelValue: () async => activity?.employerName ?? ""),
      BaseHeaderChip(label: "activity_items_responsible", labelValue: () async => activity?.responsibleName ?? ""),
      BaseHeaderChip(
          label: "activity_items_transactionType",
          labelValue: () async => activity?.transactionType.name ?? ""),
      if (locator<UserProvider>().user!.isAdmin())
        BaseHeaderChip(label: "activity_items_created_by", labelValue: () async => activity?.createUserName ?? ""),
    ];
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => ref.watch(provider.notifier).createCreditCsv(),
      child: const Image(
        image: AssetImage("assets/img/myshare-logo.png"),
        fit: BoxFit.fitWidth,
      ),
    );
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<ActivityItemsModel> get items => state.activityItems;

  @override
  BaseListState get listStatus => state.status;

  @override
  get provider => activityItemsDataProvider;
}
