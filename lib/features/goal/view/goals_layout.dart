import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/base_search_bar.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/goal/widgets/goals_maintenance.dart';
import 'package:work_hu/features/utils.dart';

class GoalsLayout extends ConsumerWidget {
  const GoalsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var goals = ref.watch(goalDataProvider).filtered;
    Future(() => ref.read(goalDataProvider).modelState == ModelState.error
        ? showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                content: SingleChildScrollView(child: Text(ref.read(goalDataProvider).message)),
                title: 'Error',
              );
            }).then((value) => ref.watch(goalDataProvider.notifier).getGoals(DateTime.now().year))
        : null);
    return Column(
      children: [
        BaseSearchBar(
          onChanged: (text) => ref.watch(goalDataProvider.notifier).filterGoals(text),
        ),
        Expanded(
          child: Stack(children: [
            RefreshIndicator(
              onRefresh: () async => ref.read(goalDataProvider.notifier).getGoals(DateTime.now().year),
              child: Column(children: [
                Expanded(
                    child: BaseListView(
                  itemBuilder: (BuildContext context, int index) {
                    var current = goals[index];
                    return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) => ref.read(goalDataProvider.notifier).deleteGoal(current.id!),
                        dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
                        child: ListCard(
                            isLast: goals.length - 1 == index,
                            index: index,
                            child: ListTile(
                              onTap: () {
                                ref.watch(goalDataProvider.notifier).setSelectedGoal(current);
                                showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => GoalsMaintenance(mode: GoalsMaintenance.EDIT))
                                    .then((value) => ref.watch(goalDataProvider.notifier).getGoals(null));
                              },
                              title: Text(current.user!.getFullName()),
                              subtitle: Text("${Utils.creditFormatting(current.user!.currentMyShareCredit)} Ft"),
                              trailing: Text(
                                "${Utils.creditFormatting(current.goal!)} Ft",
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            )));
                  },
                  itemCount: goals.length,
                  shadowColor: Colors.transparent,
                  cardBackgroundColor: Colors.transparent,
                  children: const [],
                ))
              ]),
            ),
            Positioned(
              bottom: 20.sp,
              right: 20.sp,
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  ref.watch(goalDataProvider.notifier).setSelectedGoal(const GoalModel(goal: 0));
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => GoalsMaintenance(mode: GoalsMaintenance.CREATE));
                },
              ),
            ),
            Positioned(
              bottom: 20.sp,
              left: 20.sp,
              child: FloatingActionButton(
                child: const Icon(Icons.upload),
                onPressed: () {
                  ref.read(goalDataProvider.notifier).uploadGoalsCsv();
                },
              ),
            ),
            ref.watch(goalDataProvider).modelState == ModelState.processing
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox()
          ]),
        ),
      ],
    );
  }
}
