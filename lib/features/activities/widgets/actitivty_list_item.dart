import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
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
    var user = ref.watch(userDataProvider).user!;
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: BaseContainer(
        padding: EdgeInsets.all(8.sp),
        onTap: () {
          context.push("/profile/activities/${current.id}/items").then((shouldUpdate) =>
              shouldUpdate != null && shouldUpdate == true ? ref.watch(activityDataProvider.notifier).list() : null);
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(current.transactionType == TransactionType.HOURS ? Icons.person_3_outlined : Icons.home_outlined,
                color: theme.colorScheme.primary),
          ),
          title: Text(
            current.description,
          ),
          trailing: user.isAdmin() && !current.registeredInApp
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
                          content: Text("activities_confirm_activity_register_question".i18n(), textAlign: TextAlign.center))),
                )
              : user.isAdmin() && !current.registeredInMyShare && current.transactionType != TransactionType.POINT
                  ? MaterialButton(
                      child: const Image(
                        image: AssetImage("assets/img/myshare-logo.png"),
                        fit: BoxFit.fitWidth,
                      ),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => ConfirmAlertDialog(
                              onConfirm: () {
                                ref.watch(activityDataProvider.notifier).putActivity(current.copyWith(registeredInMyShare: true));
                                context.pop();
                              },
                              title: "activities_confirm_register_in_myshare_title".i18n(),
                              content:
                                  Text("activities_confirm_register_in_myshare_question".i18n(), textAlign: TextAlign.center))),
                    )
                  : user.isAdmin() && current.registeredInMyShare && current.registeredInApp && !current.registeredInTeams
                      ? IconButton(
                          icon: Icon(
                            Icons.group,
                            size: 25.sp,
                            color: Colors.deepPurple,
                          ),
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => ConfirmAlertDialog(
                                  onConfirm: () {
                                    ref.watch(activityDataProvider.notifier).registerActivityInTeams(current.id!);
                                    context.pop();
                                  },
                                  title: "activities_confirm_register_in_teams_title".i18n(),
                                  content:
                                      Text("activities_confirm_register_in_teams_question".i18n(), textAlign: TextAlign.center))),
                        )
                      : current.registeredInMyShare && current.registeredInApp ||
                              current.registeredInApp && current.transactionType == TransactionType.POINT
                          ? const Icon(
                              Icons.done_outline,
                              color: AppColors.primaryGreen,
                            )
                          : null,
          // isThreeLine: true,
          subtitle: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "${"activity_when_where".i18n()}: ${DateFormat('yyyy, MMM dd').format(current.activityDateTime)} - ${current.employerName}",
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "${"activity_responsible".i18n()}: ${current.responsibleName} ${!user.isUser() ? "- ${current.createUserName}" : ""}",
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DateTime?> createDates() {
    var dates = <DateTime?>[];
    dates.add(null);
    for (var i = 2024; i <= DateTime.now().year; i++) {
      var month = i != DateTime.now().year ? 12 : DateTime.now().month;
      for (var j = 1; j <= month; j++) {
        dates.add(DateTime(i, j, 1));
      }
    }

    return dates;
  }
}
