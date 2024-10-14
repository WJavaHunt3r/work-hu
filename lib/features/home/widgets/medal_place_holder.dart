import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedalPlaceHolder extends StatelessWidget {
  const MedalPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.sp,
      width: 80.sp,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey, width: 1.sp)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("PACE", style: TextStyle(fontFamily: "Good-Timing", color: Colors.white, fontSize: 8.sp)),
        Text("MEDAL".toUpperCase(), style: TextStyle(fontFamily: "Good-Timing", color: Colors.white, fontSize: 7.sp)),
      ]),
    );
  }
}
