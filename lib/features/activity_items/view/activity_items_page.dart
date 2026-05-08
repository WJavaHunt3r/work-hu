import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_header_chip.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/activity_items/data/state/activity_items_state.dart';
import 'package:work_hu/features/activity_items/provider/activity_items_provider.dart';
import 'package:work_hu/features/activity_items/widgets/activity_details.dart';
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
  Widget buildListLayout(BuildContext context, WidgetRef ref) {
    var items = state.activityItems;
    var activity = state.activity;
    var listItems = items.map((e) {
      return activity?.registeredInApp ?? false || activity!.registeredInMyShare
          ? listItem(e, context, ref)
          : Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) => ref.read(provider.notifier).deleteActivityItem(e.id!, items.indexOf(e)),
              dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
              child: listItem(e, context, ref));
    });
    return Column(children: [
      // activity == null
      //     ? const SizedBox()
      //     : BaseContainer(
      //         child: ActivityItemsDetails(
      //           activity: activity,
      //           hourCount: items.map((e) => e.hours).reduce((a, b) => a + b),
      //         ),
      //       ),
      BaseListView(
        children: listItems.toList(),
      ),
    ]);
  }

  Widget listItem(ActivityItemsModel current, BuildContext context, WidgetRef ref) {
    var date = state.activity!.activityDateTime;
    var dateString = Utils.dateToString(date);
    return ListTile(
      onTap: () {},
      trailing: Text(
        "${current.hours.toString()} ${Utils.getTransactionTypeText(TransactionType.HOURS, false)}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
      ),
      title: Row(
        children: [
          Text(current.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      subtitle: Text(dateString),
    );
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
