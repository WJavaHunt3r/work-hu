import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/create_transactions/widget/add_transaction_card.dart';
import 'package:work_hu/features/create_transactions/widget/transaction_details_card.dart';
import 'package:work_hu/features/create_transactions/widget/transaction_row_widget.dart';
import 'package:work_hu/features/create_transactions/widget/transaction_sum_card.dart';

class CreateTransactionsLayout extends ConsumerWidget {
  const CreateTransactionsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(() => ref.read(createTransactionsDataProvider).creationState == ModelState.success ? context.pop() : null);
    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.sp),
          child: Column(
              children: ref.watch(createTransactionsDataProvider.notifier).descriptionController.value.text.isEmpty
                  ? [
                      const TransactionDetailsCard(),
                    ]
                  : enabledWidgets(context, ref)),
        ),
      ),
      ref.watch(createTransactionsDataProvider).modelState == ModelState.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox(),
    ]);
  }

  List<Widget> enabledWidgets(BuildContext context, WidgetRef ref) {
    var items = ref.watch(createTransactionsDataProvider).transactionItems;
    var transactionType = ref.watch(createTransactionsDataProvider).transactionType;
    var account = ref.watch(createTransactionsDataProvider).account;
    return [
      const TransactionDetailsCard(),
      SizedBox(height: 16.sp),
      TransactionSumCard(items: items),
      SizedBox(height: 16.sp),
      AddTransactionCard(
        account: account,
      ),
      SizedBox(height: 16.sp),
      Column(
        children: items.map(
          (e) {
            return TransactionRowWidget(
              name: e.userName,
              index: items.indexOf(e),
              isLast: items.indexOf(e) == items.length - 1,
              value: transactionType == TransactionType.HOURS
                  ? e.hours
                  : transactionType == TransactionType.CREDIT
                      ? e.credit
                      : e.points,
            );
          },
        ).toList(),
      ),
      SizedBox(height: 180.sp),
    ];
  }
}
