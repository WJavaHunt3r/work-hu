import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/app/widgets/success_alert_dialog.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/create_transactions/widget/selection_row.dart';

class CreateBMMTransactionLayout extends ConsumerWidget {
  const CreateBMMTransactionLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(() => ref.read(createTransactionsDataProvider).creationState == ModelState.success
        ? showDialog(
            context: context,
            builder: (context) {
              return SuccessAlertDialog(title: "create_bmm_transaction_success_message".i18n());
            })
        : null);
    return Stack(children: [
      Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: ref.watch(createTransactionsDataProvider).transactionItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = ref.watch(createTransactionsDataProvider).transactionItems[index];
                    return SelectionRow(user: item.user);
                  })),
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.sp, top: 4.sp),
                    child: TextButton(
                        onPressed: () => ref.watch(createTransactionsDataProvider.notifier).isEmpty()
                            ? showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return ErrorAlertDialog(title: "create_bmm_transaction_error_message".i18n());
                                })
                            : ref.read(createTransactionsDataProvider.notifier).sendTransactions(),
                        style: ButtonStyle(
                          side: WidgetStateBorderSide.resolveWith(
                            (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                          ),
                          backgroundColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                        ),
                        child: Text("create_bmm_transaction_send".i18n(),
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))),
                  ))
            ],
          )
        ],
      ),
      ref.watch(createTransactionsDataProvider).modelState == ModelState.processing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox(),
    ]);
  }
}
