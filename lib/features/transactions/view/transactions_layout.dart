import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/providers/transactions_provider.dart';

class TransactionsLayout extends ConsumerWidget {
  const TransactionsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var transactions = ref.watch(transactionsDataProvider).transactions;
    return Stack(children: [
      RefreshIndicator(
        onRefresh: () async => ref.read(transactionsDataProvider.notifier).getTransactions(),
        child: Column(children: [
          Expanded(
              child: BaseListView(
            itemBuilder: (BuildContext context, int index) {
              var current = transactions[index];
              var date = current.createDateTime;
              var dateString = "${date?.year}-${date?.month}-${date?.day}";
              return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) =>
                      ref.read(transactionsDataProvider.notifier).deleteTransaction(current.id!, index),
                  dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
                  child: ListCard(
                      isLast: transactions.length - 1 == index,
                      index: index,
                      child: ListTile(
                        onTap: () {
                          ref.watch(transactionItemsDataProvider.notifier).getTransactionItems(current.id!);
                          context.push("/transactionItems", extra: {"transaction": current}).then(
                              (value) => ref.watch(transactionsDataProvider.notifier).getTransactions());
                        },
                        leading: Image(
                          image: AssetImage(setLeadingIcon(current)),
                          fit: BoxFit.fitWidth,
                          width: 15.sp,
                        ),
                        title: Text(current.name),
                        subtitle: Text(dateString),
                        trailing: Text(current.transactionCount.toString()),
                      )));
            },
            itemCount: ref.watch(transactionsDataProvider).transactions.length,
            shadowColor: Colors.transparent,
            cardBackgroundColor: Colors.transparent,
            children: const [],
          ))
        ]),
      ),
      ref.watch(transactionsDataProvider).modelState == ModelState.error
          ? Center(
              child: Text(
                ref.watch(transactionsDataProvider).message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.errorRed),
              ),
            )
          : const SizedBox(),
      ref.watch(transactionsDataProvider).modelState == ModelState.processing
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox()
    ]);
  }

  String setLeadingIcon(TransactionModel current) {
    if (current.account == Account.MYSHARE) {
      return "assets/img/myshare-logo.png";
    }
    if (current.account == Account.SAMVIRK) {
      return "assets/img/Samvirk_logo.png";
    }
    return "assets/img/WORK_Logo_01_RGB.png";
  }
}
