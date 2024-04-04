import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/style/app_colors.dart';

class StatusRow extends StatelessWidget {
  StatusRow({super.key, required this.logoColor, required this.value, required this.maximum});

  final String logoColor;
  final double value;
  final double maximum;
  final NumberFormat numberFormat = NumberFormat("###.#");

  @override
  Widget build(BuildContext context) {
    final Color color = logoColor == "BLUE"
        ? AppColors.teamBlue
        : logoColor == "GREEN"
            ? AppColors.teamGreen
            : logoColor == "RED"
                ? AppColors.teamRed
                : AppColors.teamOrange;
    return ListTile(
        contentPadding: EdgeInsets.all(4.sp),
        horizontalTitleGap: 0.sp,
        leading: SizedBox(
          width: 35.sp,
          child: SvgPicture.asset(
            "assets/logos/${logoColor}_vacduka.svg",
            height: 40.sp,
            fit: BoxFit.contain,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: SfLinearGauge(
                  orientation: LinearGaugeOrientation.horizontal,
                  axisTrackStyle: LinearAxisTrackStyle(
                      thickness: 40.sp, color: Colors.transparent, edgeStyle: LinearEdgeStyle.bothCurve),
                  minimum: 0,
                  maximum: maximum,
                  showLabels: false,
                  showTicks: false,
                  markerPointers: null,
                  barPointers: [
                    LinearBarPointer(
                      thickness: 25.sp,
                      color: color,
                      edgeStyle: LinearEdgeStyle.endCurve,
                      value: value,
                    )
                  ]),
            ),
            SizedBox(
                width: 60.sp,
                child: Text(
                  numberFormat.format(value),
                  style: TextStyle(color: color, fontSize: 20.sp, fontWeight: FontWeight.w800),
                ))
          ],
        ));
  }
}
