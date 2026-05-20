import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';

class ActivityListItem extends ConsumerWidget {
  const ActivityListItem(
      {required this.isLast, required this.index, required this.current, super.key, required this.onIconPressed});

  final ActivityModel current;
  final int index;
  final bool isLast;
  final Function() onIconPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userDataProvider).user!;
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: BaseContainer(
        padding: EdgeInsets.all(8.sp),
        onTap: () {
          context
              .push("/profile/activities/${current.id}/items")
              .then((r) => r != null && r == true ? ref.read(activityDataProvider.notifier).list() : null);
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
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          trailing: !current.registeredInApp &&
                  !current.registeredInMyShare &&
                  !current.registeredInTeams &&
                  ([current.createUserId, current.responsibleId, current.employerId].contains(user.id) || user.isAdmin())
              ? IconButton(
                  onPressed: () => context
                      .push("/profile/activities/${current.id}/edit")
                      .then((value) => ref.read(activityDataProvider.notifier).list()),
                  icon: const Icon(Icons.edit_outlined))
              : user.isAdmin() && !current.registeredInApp
                  ? IconButton(
                      icon: const Icon(Icons.send_outlined),
                      onPressed: () => onIconPressed(),
                    )
                  : user.isAdmin() && !current.registeredInMyShare && current.transactionType != TransactionType.POINT
                      ? MaterialButton(
                          child: const Image(
                            image: AssetImage("assets/img/myshare-logo.png"),
                            fit: BoxFit.fitWidth,
                          ),
                          onPressed: () => onIconPressed(),
                        )
                      : user.isAdmin() && current.registeredInMyShare && current.registeredInApp && !current.registeredInTeams
                          ? IconButton(
                              icon: Icon(
                                Icons.group,
                                size: 25.sp,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () => onIconPressed(),
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
                    "${"activity_when_where".i18n()}: ${DateFormat('yyyy, MMM dd', ref.read(localeProvider).value?.languageCode).format(current.activityDateTime)} - ${current.employerName}",
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "${"activity_responsible".i18n()}: ${current.responsibleName}",
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              if (!user.isUser())
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "${"activity_create_user".i18n()}: ${current.createUserName}",
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
