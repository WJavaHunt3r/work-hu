import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/utils.dart';

class GoalsLayout extends ConsumerWidget {
  const GoalsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var goals = ref.watch(goalDataProvider).goals;
    return Column(
      children: [
        TextButton(onPressed: ()=> ref.read(goalDataProvider.notifier).uploadGoalsCsv(), child: const Text("Upload")),
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
                                // ref.watch(transactionItemsDataProvider.notifier).getTransactionItems(current.id!);
                                // context.push("/transactionItems", extra: {"transaction": current}).then(
                                //         (value) => ref.watch(goalsDataProvider.notifier).getTransactions());
                              },
                              title: Text(current.user.getFullName()),
                              subtitle: Text("${Utils.creditFormat.format(current.user.currentMyShareCredit)} Ft"),
                              trailing: Text(
                                "${Utils.creditFormat.format(current.goal)} Ft",
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            )));
                  },
                  itemCount: ref.watch(goalDataProvider).goals.length,
                  shadowColor: Colors.transparent,
                  cardBackgroundColor: Colors.transparent,
                  children: const [],
                ))
              ]),
            ),
            ref.watch(goalDataProvider).modelState == ModelState.error
                ? Center(
                    child: Text(
                      ref.watch(goalDataProvider).message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.errorRed),
                    ),
                  )
                : const SizedBox(),
            ref.watch(goalDataProvider).modelState == ModelState.processing
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox()
          ]),
        ),
      ],
    );
  }
}
