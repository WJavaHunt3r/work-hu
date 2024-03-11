import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/utils.dart';

class ActivityListItem extends ConsumerWidget {
  const ActivityListItem({required this.isLast, required this.index, required this.current, super.key});

  final ActivityModel current;
  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var date = current.activityDateTime;
    var dateString = Utils.dateToString(date);
    var user = ref.watch(userDataProvider)!;
    return ListCard(
        isLast: isLast,
        index: index,
        child: ListTile(
          onTap: () {
            context
                .push("/activityItems", extra: current.id)
                .then((value) => ref.watch(activityDataProvider.notifier).getActivities());
          },
          title: Text(
            current.description,
          ),
          trailing: user.id == 255 && !current.registeredInApp
              ? MaterialButton(
                  child: Image(
                    image: const AssetImage("assets/img/WORK_Logo_01_RGB.png"),
                    fit: BoxFit.fitWidth,
                    width: 20.sp,
                  ),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ConfirmAlertDialog(
                          onConfirm: () {
                            ref.watch(activityDataProvider.notifier).registerActivity(current.id!);
                            context.pop();
                          },
                          title: "activities_register_confirm_title".i18n(),
                          content: Text("activities_confirm_activity_register_question".i18n()))),
                )
              : user.id == 255 &&
                      !current.registeredInMyShare &&
                      current.transactionType != TransactionType.POINT
                  ? MaterialButton(
                      child: const Image(
                        image: AssetImage("assets/img/myshare-logo.png"),
                        fit: BoxFit.fitWidth,
                      ),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => ConfirmAlertDialog(
                              onConfirm: () {
                                ref.watch(activityDataProvider.notifier).putActivity(current);
                                context.pop();
                              },
                              title: "activities_confirm_register_in_myshare_title".i18n(),
                              content: Text("activities_confirm_register_in_myshare_question".i18n()))),
                    )
                  : current.registeredInMyShare && current.registeredInApp ||
                          current.registeredInApp && current.transactionType == TransactionType.POINT
                      ? const Icon(
                          Icons.done_outline,
                          color: AppColors.primaryGreen,
                        )
                      : null,
          subtitle: Row(
            children: [
              Text("$dateString - ${current.responsible.getFullName()} "),
            ],
          ),
        ));
  }
}
