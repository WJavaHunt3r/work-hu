import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.child, this.onTap, this.height, this.width, this.padding});

  final Widget child;
  final Function()? onTap;
  final double? height;
  final double? width;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
        onTap: onTap,
        child: Card(
          child: Container(
              height: height ?? 120.sp,
              width: width,
              padding: EdgeInsets.all(padding ?? 20.sp),
              child: Center(child: child)),
        ));
  }
}
