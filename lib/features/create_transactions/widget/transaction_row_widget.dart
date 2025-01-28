import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
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
          child: BaseListTile(
            leading: Text(
              (index + 1).toString(),
              style: style,
            ),
            title: Text(name, style: style),
            trailing: Text(
              "${value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1)} ${Utils.getTransactionTypeText(ref.watch(createTransactionsDataProvider).transactionType, false)}",
              style: style,
            ),
            isLast: isLast,
            index: index.toInt(),
          ),
        ));
  }
}
