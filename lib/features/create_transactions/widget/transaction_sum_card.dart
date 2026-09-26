import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class TransactionSumCard extends ConsumerWidget {
  const TransactionSumCard({super.key, required this.items});

  final List<TransactionItemModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sum = ref.watch(createTransactionsDataProvider).sum;
    return BaseContainer(
        padding: EdgeInsets.all(8.sp),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("create_transaction_count".i18n()),
                Text(
                  items.length.toStringAsFixed(0),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              children: [
                Text("create_transaction_sum"
                    .i18n([Utils.getTransactionTypeText(ref.watch(createTransactionsDataProvider).transactionType, false)])),
                Text(
                  sum % 1 == 0 ? sum.toStringAsFixed(0) : sum.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ref.watch(createTransactionsDataProvider).account == Account.MYSHARE
                ? IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: () => ref.watch(createTransactionsDataProvider).transactionType == TransactionType.CREDIT
                        ? ref.watch(createTransactionsDataProvider.notifier).createCreditsCsv()
                        : ref.watch(createTransactionsDataProvider.notifier).createHoursCsv(),
                  )
                : ref.watch(createTransactionsDataProvider).account == Account.SAMVIRK
                    ? IconButton(onPressed: () => showSamvirkImport(context, ref), icon: const Icon(Icons.upload))
                    : const SizedBox(),
            FilledButton(
                onPressed: () => ref.watch(createTransactionsDataProvider.notifier).isEmpty()
                    ? showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorAlertDialog(title: "create_transaction_warning".i18n());
                        })
                    : showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmAlertDialog(
                            onConfirm: () {
                              ref.read(createTransactionsDataProvider.notifier).sendTransactions();
                              Navigator.of(context).pop(true);
                            },
                            title: 'create_transaction_confirm_send'.i18n(),
                            content: Text("create_transaction_confirm_send_question".i18n(), textAlign: TextAlign.center),
                          );
                        }),
                style: ButtonStyle(
                  padding: WidgetStateProperty.resolveWith(
                    (states) => EdgeInsets.all(2.sp),
                  ),
                ),
                child: Text("create_transaction_send".i18n(),
                    style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w800)))
          ],
        ));
  }

  void showSamvirkImport(BuildContext context, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Set exhange rate!"),
            titleTextStyle: const TextStyle(fontWeight: FontWeight.w800),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    side: WidgetStateBorderSide.resolveWith(
                      (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                    ),
                    backgroundColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                    foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
                    overlayColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
                  ),
                  onPressed: () => context.pop(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
                    foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
                  ),
                  onPressed: () {
                    ref.watch(createTransactionsDataProvider.notifier).uploadSamvirkCsv();
                    context.pop();
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                  ))
            ],
            content: TextField(
              decoration: const InputDecoration(labelText: "Exchange rate"),
              keyboardType: TextInputType.number,
              controller: ref.watch(createTransactionsDataProvider.notifier).exchangeController,
            ),
          );
        });
  }
}
