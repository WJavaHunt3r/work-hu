import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/create_transactions/widget/add_transaction_card.dart';
import 'package:work_hu/features/create_transactions/widget/transaction_details_card.dart';
import 'package:work_hu/features/create_transactions/widget/transaction_row_widget.dart';
import 'package:work_hu/features/create_transactions/widget/transaction_sum_card.dart';

class CreateTransactionsLayout extends ConsumerWidget {
  const CreateTransactionsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(children: [
      Column(
          children: ref.watch(createTransactionsDataProvider.notifier).descriptionController.value.text.isEmpty
              ? [
                  const TransactionDetailsCard(),
                ]
              : enabledWidgets(context, ref)),
      ref.watch(createTransactionsDataProvider).modelState == ModelState.processing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox(),
    ]);
  }

  List<Widget> enabledWidgets(BuildContext context, WidgetRef ref) {
    var users = ref.watch(createTransactionsDataProvider).users;
    var items = ref.watch(createTransactionsDataProvider).transactionItems;
    var transactionType = ref.watch(createTransactionsDataProvider).transactionType;
    var account = ref.watch(createTransactionsDataProvider).account;
    return [
      const TransactionDetailsCard(),
      TransactionSumCard(items: items),
      AddTransactionCard(
        account: account,
      ),
      Expanded(
        child: SingleChildScrollView(
            child: Card(
          margin: EdgeInsets.only(bottom: 8.sp, top: 8.sp),
          color: Colors.transparent,
          child: ListView.builder(
            itemCount: ref.watch(createTransactionsDataProvider).transactionItems.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var user = users.firstWhere((u) => u.id == items[index].userId);
              return TransactionRowWidget(
                name: "${user.firstname} ${user.lastname}",
                index: index,
                isLast: index == ref.watch(createTransactionsDataProvider).transactionItems.length - 1,
                value: transactionType == TransactionType.HOURS
                    ? items[index].hours
                    : transactionType == TransactionType.CREDIT
                        ? items[index].credit
                        : items[index].points,
              );
            },
          ),
        )),
      )
    ];
  }
}
