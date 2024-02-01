import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/utils.dart';

class ActivitySumCard extends ConsumerWidget {
  const ActivitySumCard({super.key, required this.items});

  final List<ActivityItemsModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sum = ref.watch(createActivityDataProvider).sum;
    return Card(
        child: Padding(
      padding: EdgeInsets.all(8.sp),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text("Count: "),
              Text(
                items.length.toStringAsFixed(0),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            children: [
              Text(
                  "Sum (${Utils.getTransactionTypeText(ref.watch(createActivityDataProvider).transactionType, false)}): "),
              Text(
                sum % 1 == 0 ? sum.toStringAsFixed(0) : sum.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          TextButton(
              onPressed: () => ref.watch(createActivityDataProvider.notifier).isEmpty()
                  ? showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const ErrorAlertDialog(title: "Add at least one registration!");
                      })
                  : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmAlertDialog(
                          onConfirm: () {
                            ref.read(createActivityDataProvider.notifier).sendActivity();
                            context.pop(true);
                          },
                          title: 'Confirm activity registration',
                          content: const Text("Are you sure you want to send the activity registrations?",
                              textAlign: TextAlign.center),
                        );
                      }),
              style: ButtonStyle(
                padding: MaterialStateProperty.resolveWith(
                  (states) => EdgeInsets.all(2.sp),
                ),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                ),
                backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.primary),
              ),
              child: const Text("Send", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w800)))
        ],
      ),
    ));
  }
}
