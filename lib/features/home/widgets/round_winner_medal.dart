import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundWinnerMedal extends StatelessWidget {
  const RoundWinnerMedal({required this.month, super.key});

  final String month;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.sp,
      width: 80.sp,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD4Af37)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image(
            image: const AssetImage("assets/img/BUK_black_circle.png"),
            fit: BoxFit.contain,
            height: 15.sp,
          ),
          Text("PACE",
              style: TextStyle(
                  fontFamily: "Good-Timing", color: Colors.black, fontSize: 8.sp, fontWeight: FontWeight.bold)),
          Text("${month}i".toUpperCase(),
              style: TextStyle(fontFamily: "Good-Timing", color: Colors.black, fontSize: 7.sp)),
          Text("NYERTES", style: TextStyle(fontFamily: "Good-Timing", color: Colors.black, fontSize: 7.sp)),
          Image(
            image: const AssetImage("assets/img/Samvirk_logo.png"),
            fit: BoxFit.contain,
            height: 15.sp,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
