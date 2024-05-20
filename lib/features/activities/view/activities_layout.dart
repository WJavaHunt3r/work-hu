import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/base_tab_bar.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/app/widgets/success_alert_dialog.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/activities/widgets/actitivty_list_item.dart';

class ActivitiesLayout extends ConsumerWidget {
  const ActivitiesLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(() => ref.read(activityDataProvider).modelState == ModelState.empty
        ? ref.watch(activityDataProvider.notifier).getActivities()
        : null);
    Future(() => ref.read(activityDataProvider).registerState == ModelState.success
        ? showDialog(
            context: context,
            builder: (context) {
              return SuccessAlertDialog(title: ref.read(activityDataProvider).message);
            }).then((value) => ref.watch(activityDataProvider.notifier).getActivities())
        : ref.read(activityDataProvider).modelState == ModelState.error
            ? showDialog(
                context: context,
                builder: (context) {
                  return ErrorAlertDialog(title: "error".i18n(), content: Text(ref.read(activityDataProvider).message));
                })
            : null);
    var activities = ref.watch(activityDataProvider).activities;
    return Stack(children: [
      RefreshIndicator(
        onRefresh: () async => ref.read(activityDataProvider.notifier).getActivities(),
        child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: BaseTabView(
              tabs: createTabs(),
              tabViews: createTabView(activities, ref),
            )),
      ),
      ref.watch(activityDataProvider).modelState == ModelState.processing
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox()
    ]);
  }

  List<Tab> createTabs() {
    var list = <Tab>[];
    list.add(Tab(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("activities_submitted".i18n())],
    )));

    list.add(Tab(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("activities_registered".i18n())],
      ),
    ));
    return list;
  }

  List<Widget> createTabView(List<ActivityModel> items, WidgetRef ref) {
    var list = <Widget>[];

    List<ActivityModel> currentItems = items
        .where((element) => !element.registeredInApp && !element.registeredInMyShare && !element.registeredInTeams)
        .toList();
    list.add(BaseListView(
        cardBackgroundColor: Colors.transparent,
        itemBuilder: (BuildContext context, int index) {
          var current = currentItems[index];
          return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) => ref.watch(activityDataProvider.notifier).deleteActivity(current.id!, index),
              dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
              child: ActivityListItem(
                current: currentItems[index],
                index: index,
                isLast: index == currentItems.length - 1,
              ));
        },
        itemCount: currentItems.length,
        children: const []));

    List<ActivityModel> registeredItems =
        items.where((element) => element.registeredInApp || element.registeredInMyShare).toList();
    list.add(BaseListView(
        itemBuilder: (context, index) {
          return ActivityListItem(
              current: registeredItems[index], index: index, isLast: index == registeredItems.length - 1);
        },
        itemCount: registeredItems.length,
        children: const []));
    return list;
  }
}
