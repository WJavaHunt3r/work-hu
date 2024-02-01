import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/utils.dart';

class ActivitiesLayout extends ConsumerWidget {
  const ActivitiesLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(() => ref.read(activityDataProvider).modelState == ModelState.empty
        ? ref.watch(activityDataProvider.notifier).getActivities()
        : null);
    var transactions = ref.watch(activityDataProvider).activities;
    return Stack(children: [
      RefreshIndicator(
        onRefresh: () async => ref.read(activityDataProvider.notifier).getActivities(),
        child: Column(children: [
          Expanded(
              child: BaseListView(
            itemBuilder: (BuildContext context, int index) {
              var current = transactions[index];
              return current.registeredInApp || current.registeredInMyShare
                  ? listItem(transactions, context, index, ref)
                  : Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) =>
                          ref.watch(activityDataProvider.notifier).deleteActivity(current.id!, index),
                      dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
                      child: listItem(transactions, context, index, ref));
            },
            itemCount: ref.watch(activityDataProvider).activities.length,
            shadowColor: Colors.transparent,
            cardBackgroundColor: Colors.transparent,
            children: const [],
          ))
        ]),
      ),
      ref.watch(activityDataProvider).modelState == ModelState.error
          ? Center(
              child: Text(
                ref.watch(activityDataProvider).message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.errorRed),
              ),
            )
          : const SizedBox(),
      ref.watch(activityDataProvider).modelState == ModelState.processing
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox()
    ]);
  }

  Widget listItem(List<ActivityModel> transactions, BuildContext context, int index, WidgetRef ref) {
    var current = transactions[index];
    var date = current.activityDateTime;
    var dateString = Utils.dateToString(date);
    return ListCard(
        isLast: transactions.length - 1 == index,
        index: index,
        child: ListTile(
          onTap: () {
            context
                .push("/activityItems", extra: current.id)
                .then((value) => ref.watch(activityDataProvider.notifier).getActivities());
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(current.description),
              Row(
                children: [
                  current.registeredInApp
                      ? Image(
                          image: const AssetImage("assets/img/WORK_Logo_01_RGB.png"),
                          fit: BoxFit.fitWidth,
                          width: 15.sp,
                        )
                      : const SizedBox(),
                  current.registeredInMyShare
                      ? Image(
                          image: const AssetImage("assets/img/myshare-logo.png"),
                          fit: BoxFit.fitWidth,
                          width: 15.sp,
                        )
                      : const SizedBox()
                ],
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Text("${Utils.dateToString(current.activityDateTime)} - ${current.createUser.getFullName()}"),
            ],
          ),
        ));
  }
}
