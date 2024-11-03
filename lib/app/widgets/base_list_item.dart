import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseListTile extends ListTile {
  BaseListTile(
      {super.key,
      required bool isLast,
      super.enabled,
      required int index,
      super.onTap,
      super.title,
      super.trailing,
      super.subtitle,
      super.tileColor,
      super.leading,
      super.minVerticalPadding,
      super.contentPadding})
      : super(
            shape: RoundedRectangleBorder(
                borderRadius: index == 0 && isLast
                    ? BorderRadius.circular(8.sp)
                    : index == 0
                        ? BorderRadius.only(topLeft: Radius.circular(8.sp), topRight: Radius.circular(8.sp))
                        : isLast
                            ? BorderRadius.only(bottomLeft: Radius.circular(8.sp), bottomRight: Radius.circular(8.sp))
                            : BorderRadius.zero));
}
