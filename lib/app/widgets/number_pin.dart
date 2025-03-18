import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberPin extends StatelessWidget {
  const NumberPin({super.key, required this.enabled, required this.showBorder, required this.child, required this.onTap});

  final bool enabled;
  final bool showBorder;
  final Widget child;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50.sp,
        margin: EdgeInsets.all(4.sp),
        decoration: BoxDecoration(
            border: showBorder ? Border.all(color: Colors.grey) : null,
            borderRadius: BorderRadius.all(Radius.circular(4.sp))),
        child: InkResponse(
          onTap: enabled ? () => onTap() : null,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          highlightColor: Colors.grey,
          child: Center(child: child),
      ),
              ),
    );
  }
}
