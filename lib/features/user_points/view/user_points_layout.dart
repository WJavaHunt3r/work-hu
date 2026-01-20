import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/base_tab_bar.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/user_points/provider/user_points_providers.dart';
import 'package:work_hu/features/user_points/widgets/points_list_item.dart';
import 'package:work_hu/features/utils.dart';

class UserPointsLayout extends ConsumerStatefulWidget {
  const UserPointsLayout({super.key, required this.userId});

  final num userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserPointsLayoutState();
  }
}

class UserPointsLayoutState extends ConsumerState<UserPointsLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(userPointsDataProvider.notifier).setUserId(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future(() => ref.read(userPointsDataProvider).modelState == ModelState.empty
    //     ? ref.read(userPointsDataProvider.notifier).getTransactionItems()
    //     : null);
    var items = ref.watch(userPointsDataProvider).transactionItems;
    var activityItems = ref.watch(userPointsDataProvider).activityItems;
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber;
    return ref.watch(userPointsDataProvider).modelState == ModelState.processing
        ? const Center(child: CircularProgressIndicator())
        : items.isNotEmpty
            ? DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: BaseTabView(
                  tabs: createTabs(items, currentRound, context),
                  tabViews: createTabView(items, activityItems, currentRound),
                ))
            : const SizedBox();
  }

  num countItems(List<TransactionItemModel> items) {
    var count = items.map((e) => e.round!.roundNumber).toList().isNotEmpty
        ? items.map((e) => e.round!.roundNumber).toSet().toList().length
        : 0;

    return count;
  }

  List<Tab> createTabs(List<TransactionItemModel> items, num currentRound, BuildContext context) {
    String formatted = Utils.getMonthFromDate(DateTime.now(), context);
    var list = <Tab>[];
    list.add(Tab(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(formatted)],
    )));

    list.add(Tab(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("total".i18n())],
      ),
    ));
    return list;
  }

  List<Widget> createTabView(List<TransactionItemModel> items, List<ActivityItemsModel> activityItems, num currentRound) {
    var list = <Widget>[];
    List<TransactionItemModel> currentItems =
        items.where((element) => element.transactionDate.month == DateTime.now().month).toList();
    list.add(
      BaseListView(
          itemBuilder: (BuildContext context, int index) {
            var current = currentItems[index];
            return PointsListItem(
              value: current.credit,
              title: current.description,
              date: current.transactionDate,
              isLast: index == currentItems.length - 1,
              index: index,
            );
          },
          itemCount: currentItems.length,
          children: [
            activityItems.isEmpty
                ? const SizedBox()
                : Text(
                    "user_points_waiting_for_approval".i18n(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.sp),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var current = activityItems[index];
                    return PointsListItem(
                      value: current.hours,
                      title: current.description,
                      date: current.activity?.activityDateTime ?? DateTime.now(),
                      isLast: index == activityItems.length - 1,
                      index: index,
                    );
                  },
                  itemCount: activityItems.length),
            )
          ]),
    );

    list.add(BaseListView(
        itemBuilder: (context, index) {
          var current = items[index];
          return PointsListItem(
              value: current.credit,
              title: current.description,
              date: current.transactionDate,
              isLast: index == items.length - 1,
              index: index);
        },
        itemCount: items.length,
        children: const []));
    return list;
  }
}
