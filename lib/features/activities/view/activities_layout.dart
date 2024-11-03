import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/base_tab_bar.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/app/widgets/success_alert_dialog.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/activities/widgets/actitivty_list_item.dart';
import 'package:work_hu/features/utils.dart';

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
              tabViews: createTabView(activities, ref, context),
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

  List<Widget> createTabView(List<ActivityModel> items, WidgetRef ref, BuildContext context) {
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
              onDismissed: (direction) => showDialog(
                      context: context,
                      builder: (buildContext) {
                        return ConfirmAlertDialog(
                          onConfirm: () => buildContext.pop(true),
                          title: "delete".i18n(),
                          content: Text("activity_delete_warning".i18n(), textAlign: TextAlign.center),
                        );
                      })
                  .then((confirmed) => confirmed != null && confirmed
                      ? ref.watch(activityDataProvider.notifier).deleteActivity(current.id!, index)
                      : null)
                  .then((value) => ref.read(activityDataProvider.notifier).getActivities()),
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
    list.add(Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.sp, bottom: 4.sp),
          child: DropdownButtonFormField<DateTime?>(
              decoration: InputDecoration(labelText: "activity_reference_date".i18n()),
              value: DateTime(DateTime.now().year, DateTime.now().month, 1),
              items: createDates()
                  .map((e) => DropdownMenuItem<DateTime?>(
                        value: e,
                        child: Text(e == null ? "" : "${e.year} - ${Utils.getMonthFromDate(e, context)}"),
                      ))
                  .toList(),
              onChanged: (value) => ref.watch(activityDataProvider.notifier).setReferenceDate(value)),
        ),
        Expanded(
          child: BaseListView(
              itemBuilder: (context, index) {
                return ActivityListItem(
                    current: registeredItems[index], index: index, isLast: index == registeredItems.length - 1);
              },
              itemCount: registeredItems.length,
              children: const []),
        ),
      ],
    ));
    return list;
  }

  List<DateTime?> createDates() {
    var dates = <DateTime?>[];
    dates.add(null);
    for (var i = 2024; i <= DateTime.now().year; i++) {
      var month = i != DateTime.now().year ? 12 : DateTime.now().month;
      for (var j = 1; j <= month; j++) {
        dates.add(DateTime(i, j, 1));
      }
    }

    return dates;
  }
}
