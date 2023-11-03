import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/base_tab_bar.dart';
import 'package:work_hu/app/widgets/list_separator.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/user_points/provider/user_points_providers.dart';
import 'package:work_hu/features/user_points/widgets/points_list_item.dart';

class UserPointsLayout extends ConsumerWidget {
  const UserPointsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var items = ref.watch(userPointsDataProvider).transactionItems;
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber.toInt();
    return DefaultTabController(
        length: countItems(items).toInt() + 1,
        initialIndex: currentRound == 0 || countItems(items).toInt() == 0 ? 0 : currentRound - 1,
        child: Column(
          children: [
            BaseTabBar(
              tabs: createTabs(items),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.sp),
                child: TabBarView(clipBehavior: Clip.antiAlias, children: createTabView(items)),
              ),
            ),
          ],
        ));
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
        children: [Text("Round ${i}")],
      )));
    }
    list.add(const Tab(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Total")],
      ),
    ));
    return list;
  }

  List<Widget> createTabView(List<TransactionItemModel> items) {
    var count = countItems(items);
    var list = <Widget>[];
    for (num i = 1; i <= count; i++) {
      List<TransactionItemModel> currentItems = items.where((element) => element.round!.roundNumber == i).toList();
      list.add(BaseListView(
          itemBuilder: (BuildContext context, int index) {
            var current = currentItems[index];
            return PointsListItem(
                transactionType: current.transactionType,
                value: current.points,
                title: current.description,
                date: current.transactionDate);
          },
          itemCount: currentItems.length,
          children: const []));
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
