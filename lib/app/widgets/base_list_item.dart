import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseListTile extends StatelessWidget {
  BaseListTile(
      {super.key,
      required this.isLast,
      this.enabled = true,
      required this.index,
      this.onTap,
      required this.title,
      this.trailing,
      this.subtitle,
      this.tileColor,
      this.leading,
      this.minVerticalPadding,
      this.contentPadding,
      this.selected});

  final EdgeInsets? contentPadding;
  final double? minVerticalPadding;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final Color? tileColor;
  final bool isLast;
  final bool enabled;
  final int index;
  final Function()? onTap;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
      enabled: enabled,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      minVerticalPadding: minVerticalPadding,
      onTap: onTap,
      leading: leading,
      selected: selected ?? false,
      title: title,
      subtitle: subtitle,
      tileColor: tileColor,
      trailing: trailing,
      shape: RoundedRectangleBorder(
          borderRadius: index == 0 && isLast
              ? BorderRadius.circular(24.sp)
              : index == 0
                  ? BorderRadius.only(topLeft: Radius.circular(24.sp), topRight: Radius.circular(24.sp))
                  : isLast
                      ? BorderRadius.only(bottomLeft: Radius.circular(24.sp), bottomRight: Radius.circular(24.sp))
                      : BorderRadius.zero),
    );
  }
}
