import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
          trailing: user.role == Role.ADMIN && !current.registeredInApp
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
                          title: "Register Activity",
                          content: const Text("Are you sure you register this activity"))),
                )
              : user.role == Role.ADMIN && !current.registeredInMyShare
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
                              title: "Register in MyShare",
                              content:
                                  const Text("Are you sure you want to set this activity as registered in MyShare?"))),
                    )
                  : current.registeredInMyShare && current.registeredInApp
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
