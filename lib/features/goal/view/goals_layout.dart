import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/app/widgets/loading_screen.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/goal/widgets/goals_maintenance.dart';
import 'package:work_hu/features/utils.dart';

class GoalsLayout extends ConsumerStatefulWidget {
  const GoalsLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => GoalsLayoutState();
}

class GoalsLayoutState extends ConsumerState<GoalsLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(goalDataProvider.notifier).getGoals(DateTime.now().year));
  }

  @override
  Widget build(BuildContext context) {
    var goals = ref.watch(goalDataProvider).filtered;
    ref.listen(goalDataProvider, (prev, next) {
      next.modelState.isError
          ? showDialog(
              context: context,
              builder: (context) {
                return ErrorAlertDialog(
                  content: SingleChildScrollView(child: Text(ref.read(goalDataProvider).message)),
                  title: 'Error',
                );
              }).then((v) => ref.read(goalDataProvider.notifier).getGoals(DateTime.now().year))
          : null;

      if (next.modelState.isProcessing) {
        LoadingScreen.instance().show(context: context);
      } else {
        LoadingScreen.instance().hide();
      }
    });

    return Column(
      children: [
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
                        child: Card(
                            margin: const EdgeInsets.all(0),
                            child: BaseListTile(
                              isLast: goals.length - 1 == index,
                              index: index,
                              onTap: () {
                                ref.watch(goalDataProvider.notifier).presetGoal(current, MaintenanceMode.edit);
                                showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => const GoalsMaintenance())
                                    .then((value) => ref.watch(goalDataProvider.notifier).getGoals(null));
                              },
                              title: Text(current.user!.getFullName()),
                              subtitle: Text("${Utils.creditFormatting(current.user!.currentMyShareCredit)} Ft"),
                              trailing: Text(
                                "${Utils.creditFormatting(current.goal)} Ft",
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
                heroTag: UniqueKey(),
                onPressed: () {
                  ref.watch(goalDataProvider.notifier).presetGoal(const GoalModel(goal: 0), MaintenanceMode.create);
                  showDialog(barrierDismissible: false, context: context, builder: (context) => const GoalsMaintenance());
                },
                child: const Icon(Icons.add),
              ),
            ),
            Positioned(
              bottom: 20.sp,
              left: 20.sp,
              child: FloatingActionButton(
                heroTag: UniqueKey(),
                child: const Icon(Icons.upload),
                onPressed: () {
                  ref.read(goalDataProvider.notifier).uploadGoalsCsv();
                },
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
