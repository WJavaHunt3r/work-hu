import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/utils.dart';

class PointsListItem extends StatelessWidget {
  const PointsListItem(
      {super.key,
      required this.value,
      required this.title,
      required this.date,
      required this.isLast,
      required this.index});

  final num value;
  final String title;
  final DateTime date;

  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BaseListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
      title: Text(
        title,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
      ),
      trailing: Text(
        "${Utils.creditFormatting(value)} p",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
          "${date.month < 10 ? "0${date.month}" : date.month}.${date.day < 10 ? "0${date.day}" : date.day}",
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
      isLast: isLast,
      index: index,
    );
  }
}
