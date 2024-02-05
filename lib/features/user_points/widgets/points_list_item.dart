import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';

class PointsListItem extends StatelessWidget {
  const PointsListItem(
      {required this.transactionType, super.key, required this.value, required this.title, required this.date});

  final TransactionType transactionType;
  final num value;
  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(5.sp),
      title: Text(
        title,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
      ),
      trailing: Text(
        value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
      subtitle: Text("${date.month < 10 ? "0${date.month}" : date.month}.${date.day < 10 ? "0${date.day}" : date.day}",
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
    );
  }
}
