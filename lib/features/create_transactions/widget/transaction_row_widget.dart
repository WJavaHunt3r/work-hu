import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/utils.dart';

class TransactionRowWidget extends ConsumerWidget {
  const TransactionRowWidget(
      {super.key, required this.index, required this.name, required this.value, required this.isLast});

  final num index;
  final String name;
  final num value;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var style = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp);
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) => ref.read(createTransactionsDataProvider.notifier).deleteTransaction(index.toInt()),
        dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
        child: Card(
          margin: EdgeInsets.all(0.sp),
          elevation: 0.sp,
          child: ListTile(
              tileColor:
                  ref.watch(createTransactionsDataProvider).transactionType == TransactionType.HOURS && value > 10
                      ? AppColors.redRowBgColor
                      : AppColors.white,
              leading: Text(
                (index + 1).toString(),
                style: style,
              ),
              title: Text(name, style: style),
              trailing: Text(
                "${value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1)} ${Utils.getTransactionTypeText(ref.watch(createTransactionsDataProvider).transactionType, false)}",
                style: style,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: index == 0 && isLast
                      ? BorderRadius.circular(8.sp)
                      : index == 0
                          ? BorderRadius.only(topLeft: Radius.circular(8.sp), topRight: Radius.circular(8.sp))
                          : isLast
                              ? BorderRadius.only(bottomLeft: Radius.circular(8.sp), bottomRight: Radius.circular(8.sp))
                              : BorderRadius.zero)),
        ));
  }
}
