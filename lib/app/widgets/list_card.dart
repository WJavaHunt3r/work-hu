import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.isLast, required this.child, required this.index});

  final bool isLast;
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(0),
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: index == 0 && isLast
                ? BorderRadius.circular(8.sp)
                : index == 0
                    ? BorderRadius.only(topLeft: Radius.circular(8.sp), topRight: Radius.circular(8.sp))
                    : isLast
                        ? BorderRadius.only(bottomLeft: Radius.circular(8.sp), bottomRight: Radius.circular(8.sp))
                        : BorderRadius.zero),
        child: child);
  }
}
