import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/icon_box.dart';

class TransactionTile extends StatelessWidget {
  final String title, date, amount;
  final TransactionType transactionType;

  const TransactionTile(
      {super.key, required this.title, required this.date, required this.amount, required this.transactionType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: BaseContainer(
        padding: EdgeInsets.all(12.sp),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading:
              IconBox(icon: transactionType == TransactionType.CREDIT ? Icons.monetization_on_outlined : Icons.task_outlined),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(date, style: Theme.of(context).textTheme.bodySmall),
          trailing: Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

