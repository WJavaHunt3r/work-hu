import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/goal/data/model/goal_filter.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
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

class GoalPageState extends PagedListPageState<GoalPage, GoalModel, GoalFilter, GoalDataNotifier> {
  @override
  Widget build(BuildContext context) {
    // Keeps the maintenance state alive between presetting a goal and the dialog watching it.
    ref.listen(goalMaintenanceProvider, (previous, next) {});
    return super.build(context);
  }

  @override
  Widget buildListTile(GoalModel item, int index) {
    return BaseListTile(
      isLast: index == items.length - 1,
      index: index,
      onTap: () => _openMaintenance(item, MaintenanceMode.edit),
      title: Text(item.username!),
      // subtitle: Text("${Utils.creditFormatting(current.user!.currentMyShareCredit ?? 0)} Ft"),
      trailing: Text(Utils.creditFormatting(item.goal), style: TextStyle(fontSize: 18.sp)),
    );
  }

  @override
  bool canDelete(GoalModel item) => item.seasonYear == DateTime.now().year;

  @override
  void onDelete(GoalModel item) => notifier.deleteGoal(item.id!);

  @override
  get provider => goalDataProvider;

  @override
  buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _openMaintenance(const GoalModel(goal: 0), MaintenanceMode.create),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _openMaintenance(GoalModel goal, MaintenanceMode mode) async {
    await ref.read(goalMaintenanceProvider.notifier).presetGoal(goal, mode);
    if (!mounted) return;
    final saved = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) => GoalsMaintenance(),
    );
    if (saved == true) notifier.reload();
  }
}
