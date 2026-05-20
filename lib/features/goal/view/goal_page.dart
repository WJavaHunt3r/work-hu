import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/goal/data/state/goal_state.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/goal/widgets/goals_maintenance.dart';
import 'package:work_hu/features/utils.dart';

class GoalPage extends BaseListPage {
  const GoalPage({super.key, super.title = "admin_goals"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return GoalPageState();
  }
}

class GoalPageState extends BaseListPageState<GoalPage, GoalState, GoalDataNotifier> {
  @override
  Widget buildListTile(item) {
    var index = items.indexOf(item);
    return BaseListTile(
      isLast: items.length - 1 == index,
      index: index,
      onTap: () {
        ref.watch(goalDataProvider.notifier).presetGoal(item, MaintenanceMode.edit);
        showDialog(barrierDismissible: false, context: context, builder: (context) => GoalsMaintenance())
            .then((value) => value != null && value == true ? ref.watch(goalDataProvider.notifier).list() : null);
      },
      title: Text(item.username!),
      // subtitle: Text("${Utils.creditFormatting(current.user!.currentMyShareCredit ?? 0)} Ft"),
      trailing: Text(
        Utils.creditFormatting(item.goal),
        style: TextStyle(fontSize: 18.sp),
      ),
    );
  }

  @override
  bool canDelete(item) {
    item as GoalModel;
    return item.seasonYear == DateTime.now().year;
  }

  @override
  onDelete(e) {
    ref.read(goalDataProvider.notifier).deleteGoal(e.id!);
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<dynamic> get items => state.goals;

  @override
  BaseListState get listStatus => state.listState;

  @override
  AutoDisposeStateNotifierProvider<GoalDataNotifier, GoalState> get provider => goalDataProvider;

  @override
  buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => showDialog(barrierDismissible: false, context: context, builder: (context) => GoalsMaintenance())
          .then((value) => value != null && value == true ? ref.watch(goalDataProvider.notifier).list() : null),
      child: const Icon(Icons.add),
    );
  }
}
