import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlyCoin extends StatelessWidget {
  final String month;
  final num points;

  const MonthlyCoin({super.key, required this.month, required this.points});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
      height: 110.sp,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              month,
              overflow: TextOverflow.ellipsis,
            ),
            Image(
                height: 80.sp,
                width: 80.sp,
                image: AssetImage(
                    "assets/img/${points == 0 ? "PACE_Coin_Blank_Static.png" : "PACE_Coin_Buk_${points}_Spin_540px.gif"}"),
                fit: BoxFit.fitWidth)
          ],
        ),
      ),
    ));
  }
}
