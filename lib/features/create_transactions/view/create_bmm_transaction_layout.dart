import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              return const SuccessAlertDialog(title: "BMM points successfully submitted");
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
                  child: TextButton(
                      onPressed: () => ref.watch(createTransactionsDataProvider.notifier).isEmpty()
                          ? showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return const ErrorAlertDialog(title: "Select at least one person!");
                              })
                          : ref.read(createTransactionsDataProvider.notifier).sendTransactions(),
                      style: ButtonStyle(
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                        ),
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                      ),
                      child:
                          const Text("Send", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))))
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
