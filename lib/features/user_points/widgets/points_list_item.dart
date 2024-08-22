import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/features/utils.dart';

class PointsListItem extends StatelessWidget {
  const PointsListItem({super.key, required this.value, required this.title, required this.date});

  final num value;
  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
      title: Text(
        title,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
      ),
      trailing: Text(
        Utils.creditFormatting(value),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
      subtitle: Text("${date.month < 10 ? "0${date.month}" : date.month}.${date.day < 10 ? "0${date.day}" : date.day}",
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
    );
  }
}
