import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/style/app_colors.dart';

class StatusColumn extends StatelessWidget {
  StatusColumn(
      {super.key,
      required this.teamName,
      required this.value,
      required this.maximum,
      required this.linearElementPosition});

  final String teamName;
  final num value;
  final num maximum;
  final NumberFormat numberFormat = NumberFormat("###.#");
  final LinearElementPosition linearElementPosition;

  @override
  Widget build(BuildContext context) {
    final Color color = teamName == "Team Samvirk" ? AppColors.teamOrange : AppColors.teamBlue;
    return SfLinearGauge(
        orientation: LinearGaugeOrientation.vertical,
        axisTrackStyle: LinearAxisTrackStyle(
            thickness: 50.w,
            borderColor: Colors.grey.shade500,
            color: Colors.transparent,
            edgeStyle: LinearEdgeStyle.bothFlat),
        minimum: 0,
        maximum: maximum.toDouble(),
        showLabels: false,
        showTicks: false,
        markerPointers: [
          LinearWidgetPointer(
            offset: 10,
            markerAlignment: LinearMarkerAlignment.center,
            position: linearElementPosition,
            dragBehavior: LinearMarkerDragBehavior.constrained,
            value: value.toDouble(),
            child: Text(
              value.toString(),
              style: TextStyle(fontFamily: "Good-Timing", fontSize: 16.sp),
            ),
          ),
          if (value != maximum)
            LinearWidgetPointer(
              offset: 10,
              markerAlignment: LinearMarkerAlignment.center,
              position: linearElementPosition,
              dragBehavior: LinearMarkerDragBehavior.constrained,
              value: maximum.toDouble(),
              child: Text(
                maximum.toString(),
                style: TextStyle(fontFamily: "Good-Timing", fontSize: 12.sp),
              ),
            )
        ],
        barPointers: [
          LinearBarPointer(
            thickness: 50.w,
            color: color,
            edgeStyle: LinearEdgeStyle.bothFlat,
            value: value.toDouble(),
          ),
          LinearBarPointer(
              thickness: 50.w,
              color: Colors.transparent,
              enableAnimation: false,
              borderColor: Colors.grey,
              borderWidth: 0.5.w,
              edgeStyle: LinearEdgeStyle.bothFlat,
              value: maximum.toDouble())
        ]);
  }
}
