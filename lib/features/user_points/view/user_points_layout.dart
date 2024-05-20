import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/base_tab_bar.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/user_points/provider/user_points_providers.dart';
import 'package:work_hu/features/user_points/widgets/points_list_item.dart';

class UserPointsLayout extends ConsumerWidget {
  const UserPointsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var items = ref.watch(userPointsDataProvider).transactionItems;
    var activityItems = ref.watch(userPointsDataProvider).activityItems;
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber;
    return items.isNotEmpty
        ? DefaultTabController(
            length: currentRound.toInt() + 1,
            initialIndex: currentRound == 0 ? 0 : currentRound.toInt() - 1,
            child: BaseTabView(
              tabs: createTabs(items),
              tabViews: createTabView(items, activityItems),
            ))
        : const SizedBox();
  }

  num countItems(List<TransactionItemModel> items) {
    var count = items.map((e) => e.round!.roundNumber).toList().isNotEmpty
        ? items.map((e) => e.round!.roundNumber).toSet().toList().length
        : 0;

    return count;
  }

  List<Tab> createTabs(List<TransactionItemModel> items) {
    var count = countItems(items);
    var list = <Tab>[];
    for (num i = 1; i <= count; i++) {
      list.add(Tab(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("round_number".i18n([i.toString()]))
        ],
      )));
    }
    list.add(Tab(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("total".i18n())],
      ),
    ));
    return list;
  }

  List<Widget> createTabView(List<TransactionItemModel> items, List<ActivityItemsModel> activityItems) {
    var count = countItems(items);
    var list = <Widget>[];
    for (num i = 1; i <= count; i++) {
      List<TransactionItemModel> currentItems = items.where((element) => element.round!.roundNumber == i).toList();
      list.add(
        BaseListView(
            itemBuilder: (BuildContext context, int index) {
              var current = currentItems[index];
              return PointsListItem(
                  transactionType: current.transactionType,
                  value: current.points,
                  title: current.description,
                  date: current.transactionDate);
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
                          transactionType: current.transactionType,
                          value: current.hours * 4,
                          title: current.description,
                          date: current.activity?.activityDateTime ?? DateTime.now());
                    },
                    itemCount: activityItems.length),
              )
            ]),
      );
    }
    list.add(BaseListView(
        itemBuilder: (context, index) {
          var current = items[index];
          return PointsListItem(
              transactionType: current.transactionType,
              value: current.points,
              title: current.description,
              date: current.transactionDate);
        },
        itemCount: items.length,
        children: const []));
    return list;
  }
}
