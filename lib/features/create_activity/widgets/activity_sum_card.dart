import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/utils.dart';

class ActivitySumCard extends ConsumerWidget {
  const ActivitySumCard({super.key, required this.items});

  final List<ActivityItemsModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sum = ref.watch(createActivityDataProvider).sum;
    return BaseContainer(
        padding: EdgeInsets.all(8.sp),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("create_activity_count".i18n()),
                Text(
                  items.length.toStringAsFixed(0),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              children: [
                Text("create_activity_sum"
                    .i18n([Utils.getTransactionTypeText(ref.watch(createActivityDataProvider).transactionType, false)])),
                Text(
                  sum % 1 == 0 ? sum.toStringAsFixed(0) : sum.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(ref.watch(createActivityDataProvider).account == Account.MYSHARE &&
                        TransactionType.HOURS == (ref.watch(createActivityDataProvider).transactionType)
                    ? " (${(sum * 3000).toInt()} Ft)"
                    : TransactionType.DUKA_MUNKA_2000 == (ref.watch(createActivityDataProvider).transactionType)
                        ? " (${(sum * 2000).toInt()} Ft)"
                        : ref.watch(createActivityDataProvider).account == Account.MYSHARE &&
                                ref.watch(createActivityDataProvider).transactionType == TransactionType.DUKA_MUNKA
                            ? " (${(sum * 1000).toInt()} Ft)"
                            : "")
              ],
            ),
            FilledButton(
                onPressed: () => ref.watch(createActivityDataProvider.notifier).isEmpty()
                    ? showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorAlertDialog(title: "create_activity_warning".i18n());
                        })
                    : showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmAlertDialog(
                            onConfirm: () {
                              ref.read(createActivityDataProvider.notifier).sendActivity();
                              Navigator.of(context).pop();
                            },
                            title: "create_confirm_activity_send".i18n(),
                            content: Text("create_confirm_activity_send_question".i18n(), textAlign: TextAlign.center),
                          );
                        }),
                child: const Text("create_activity_send"))
          ],
        ));
  }
}
