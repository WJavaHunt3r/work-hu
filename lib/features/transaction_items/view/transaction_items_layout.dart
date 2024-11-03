import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/utils.dart';

class TransactionsLayout extends ConsumerWidget {
  const TransactionsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var transactionItems = ref.watch(transactionItemsDataProvider).transactionItems;
    var transaction = ref.watch(transactionItemsDataProvider).transaction;
    return Stack(
      children: [
        transaction == null
            ? const SizedBox()
            : RefreshIndicator(
                onRefresh: () async =>
                    ref.watch(transactionItemsDataProvider.notifier).getTransactionItems(transaction.id!),
                child: Column(children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transaction Details",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Description"),
                              Expanded(
                                  child: Text(
                                transaction.name,
                                textAlign: TextAlign.end,
                              ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Transaction Date"),
                              Text(Utils.dateToString(transactionItems.isNotEmpty
                                  ? transactionItems.first.transactionDate
                                  : transaction.createDateTime!))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: BaseListView(
                          itemCount: transactionItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            var current = transactionItems[index];
                            bool isLast = transactionItems.length - 1 == index;
                            return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) => ref
                                    .read(transactionItemsDataProvider.notifier)
                                    .deleteTransactionItem(current.id!, index),
                                dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
                                child: Card(
                                  margin: const EdgeInsets.all(0),
                                  child: BaseListTile(
                                      isLast: isLast,
                                      index: index,
                                      title: Text(current.user.getFullName()),
                                      trailing: Text(
                                        createTrailingText(current),
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                                      )),
                                ));
                          },
                          children: const []))
                ]),
              ),
        Positioned(
            bottom: 20.sp,
            left: 20.sp,
            child: transaction != null && transaction.account == Account.MYSHARE
                ? FloatingActionButton(
                    onPressed: () => ref.read(transactionItemsDataProvider.notifier).createCreditsCsv(),
                    child: const Icon(Icons.download),
                  )
                : const SizedBox()),
        ref.watch(transactionItemsDataProvider).modelState == ModelState.error
            ? Center(
                child: Text(
                  ref.read(transactionItemsDataProvider).message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.errorRed),
                ),
              )
            : const SizedBox(),
        ref.watch(transactionItemsDataProvider).modelState == ModelState.processing
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox()
      ],
    );
  }

  String createTrailingText(TransactionItemModel current) {
    if (current.transactionType == TransactionType.CREDIT) {
      return "${Utils.creditFormatting(current.credit)} Ft";
    }
    if (current.transactionType == TransactionType.HOURS) {
      return "${current.hours} h";
    }
    return "${Utils.percentFormat.format(current.points)} p";
  }
}
