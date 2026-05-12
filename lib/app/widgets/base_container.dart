import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseContainer extends StatelessWidget {
  const BaseContainer({super.key, required this.child, this.height, this.width, this.padding, this.color, this.onTap});

  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final Color? color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
          padding: padding ?? EdgeInsets.all(24.sp),
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24.sp),
              boxShadow: Theme.of(context).brightness == Brightness.dark
                  ? null
                  : [
                      BoxShadow(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                          blurRadius: 5.sp,
                          spreadRadius: 2.sp)
                    ]),
          child: Material(
              surfaceTintColor: Colors.transparent,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24.sp),
              child: child)),
    );
  }
}
