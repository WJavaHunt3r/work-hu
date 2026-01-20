import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/user_fra_kare_week/provider/user_fra_kare_week_provider.dart';
import 'package:work_hu/features/user_fra_kare_week/widgets/selection_row.dart';

class UserFraKareWeekLayout extends ConsumerWidget {
  const UserFraKareWeekLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var streaks = ref.watch(userFraKareWeekDataProvider).streaks;
    return Stack(children: [
      Column(
        children: [
          Expanded(
              child: BaseListView(
            itemCount: streaks.length,
            itemBuilder: (BuildContext context, int index) {
              var item = streaks[index];
              return SelectionRow(
                fraKareWeek: item,
                isLast: index == streaks.length - 1,
                index: index,
              );
            },
            children: const [],
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
                            content: Text("user_fra_fare_week_save_question".i18n(), textAlign: TextAlign.center),
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
}
