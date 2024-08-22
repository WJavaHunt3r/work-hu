import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/app/widgets/work_drop_down_dearch_form_field.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

class GoalsMaintenance extends ConsumerWidget {
  const GoalsMaintenance({required this.mode, super.key});

  final String mode;

  static final _formKey = GlobalKey<FormState>();

  static const String CREATE = "*CREATE";
  static const String EDIT = "*EDIT";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoalModel goal = ref.watch(goalDataProvider).selectedGoal;
    return Dialog.fullscreen(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "${mode.toLowerCase().substring(1, mode.length)}_goal".i18n(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          MaterialButton(
            onPressed: () => ref.read(goalDataProvider.notifier).saveGoal(mode).then((value) => context.pop()),
            child: const Text("Save"),
          )
        ],
      ),
      body: Form(
          key: _formKey,
          onPopInvoked: (pop) => ref.read(goalDataProvider.notifier).setSelectedGoal(const GoalModel(goal: 0)),
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("goal_maintenance_user".i18n()),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: WorkDropDownSearchFormField<UserModel>(
                      enabled: true,
                      direction: AxisDirection.down,
                      onTap: () => ref.watch(goalDataProvider.notifier).userController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: ref.watch(goalDataProvider.notifier).userController.value.text.length),
                      onSuggestionSelected: (UserModel suggestion) =>
                          ref.watch(goalDataProvider.notifier).updateGoal(goal.copyWith(user: suggestion)),
                      itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
                      suggestionsCallback: (String pattern) => ref.read(goalDataProvider.notifier).filterUsers(pattern),
                      controller: ref.watch(goalDataProvider.notifier).userController,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaseTextFormField(
                        enabled: false,
                        labelText: "goal_maintenance_season".i18n(),
                        initialValue: goal.season == null ? "0" : goal.season!.seasonYear.toString(),
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
                            ? ref
                                .watch(goalDataProvider.notifier)
                                .updateGoal(goal.copyWith(goal: num.tryParse(text) ?? 0))
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
