import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';
import 'package:work_hu/features/user_fra_kare_week/provider/user_fra_kare_week_provider.dart';
import 'package:work_hu/features/user_fra_kare_week/widgets/selection_row.dart';
import 'package:work_hu/features/user_status/widgets/base_filter_chip.dart';

class UserFraKareWeekLayout extends ConsumerWidget {
  const UserFraKareWeekLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var streaks = ref.watch(userFraKareWeekDataProvider).streaks;
    return Stack(children: [
      Column(
        children: [
          ref.watch(userDataProvider)!.role == Role.ADMIN
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.sp),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 30.sp,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: createTeamFilterChips(context, ref)),
                              Text("${streaks.where((e) => e.listened).length} / ${streaks.length.toString()}")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
          Expanded(
              child: BaseListView(
            itemCount: ref.watch(userFraKareWeekDataProvider).streaks.length,
            itemBuilder: (BuildContext context, int index) {
              var item = ref.watch(userFraKareWeekDataProvider).streaks[index];
              return SelectionRow(fraKareWeek: item);
            },
            children: [],
          )),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(bottom: 8.sp, top: 4.sp),
                child: TextButton(
                    onPressed: () => showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmAlertDialog(
                            title: "user_fra_fare_week_save".i18n(),
                            onConfirm: () {
                              context.pop();
                              ref.read(userFraKareWeekDataProvider.notifier).saveUserFraKareWeeks();
                            },
                            content: Text("user_fra_fare_week_save_question".i18n()),
                          );
                        }),
                    style: ButtonStyle(
                      side: WidgetStateBorderSide.resolveWith(
                        (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                      ),
                      backgroundColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                    ),
                    child: Text("user_fra_fare_week_save".i18n(),
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))),
              ))
            ],
          )
        ],
      ),
      ref.watch(userFraKareWeekDataProvider).modelState == ModelState.processing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox(),
    ]);
  }

  List<Widget> createTeamFilterChips(BuildContext context, WidgetRef ref) {
    List<Widget> chips = [];
    for (var team in ref.watch(teamRoundDataProvider).teams.map((e) => e.team).toSet()) {
      bool isSelected = ref.watch(userFraKareWeekDataProvider).selectedTeamId == team.id;
      chips.add(BaseFilterChip(
          isSelected: isSelected,
          title: team.teamName,
          onSelected: (bool selected) =>
              ref.watch(userFraKareWeekDataProvider.notifier).setSelectedFilter(selected ? team : null)));
    }
    return chips;
  }
}
