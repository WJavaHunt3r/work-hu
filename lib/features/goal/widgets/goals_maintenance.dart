import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/app/widgets/work_drop_down_dearch_form_field.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/view/user_combo.dart';

class GoalsMaintenance extends ConsumerWidget {
  GoalsMaintenance({super.key});

  final TextEditingController userController = TextEditingController();

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(goalDataProvider).mode;
    final GoalModel goal = ref.watch(goalDataProvider).selectedGoal;
    var year = goal.seasonYear;
    return Dialog.fullscreen(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(false),
        ),
        title: Text(
          "${mode}_goal".i18n(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          MaterialButton(
            onPressed: () => ref.read(goalDataProvider.notifier).saveGoal().then((value) => context.pop(true)),
            child: const Text("Save"),
          )
        ],
      ),
      body: goal.seasonYear == null
          ? const SizedBox()
          : Form(
              key: _formKey,
              onPopInvoked: (pop) =>
                  ref.read(goalDataProvider.notifier).presetGoal(const GoalModel(goal: 0), MaintenanceMode.create),
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: UserComboWidget(
                          initValue: goal.userId,
                          controller: userController,
                          fldControl: mode == MaintenanceMode.create ? "3" : "1",
                          onSuggestionSelected: (UserComboModel suggestion) => ref
                              .watch(goalDataProvider.notifier)
                              .updateGoal(goal.copyWith(userId: suggestion.id, username: suggestion.lastname)),
                          labelText: "goal_maintenance_user".i18n(),
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: BaseTextFormField(
                            enabled: false,
                            labelText: "goal_maintenance_season".i18n(),
                            initialValue: goal.seasonYear == null ? "0" : goal.seasonYear.toString(),
                            onChanged: (season) => {},
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 2,
                          child: BaseTextFormField(
                            labelText: "goal_maintenance_goal".i18n(),
                            initialValue: goal.goal.toString(),
                            keyBoardType: TextInputType.number,
                            onChanged: (String text) => text.isNotEmpty
                                ? ref.watch(goalDataProvider.notifier).updateGoal(goal.copyWith(goal: num.tryParse(text) ?? 0))
                                : null,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
    ));
  }
}
