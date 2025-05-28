import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/utils.dart';

class StatusRow extends StatelessWidget {
  StatusRow({super.key, required this.statName, required this.value, required this.maximum, required this.color});

  final String statName;
  final num value;
  final num maximum;
  final Color color;
  final NumberFormat numberFormat = NumberFormat("###.#");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 20.sp),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 4.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                      statName,
                      style: TextStyle(fontSize: 14.sp, color: color),
                    )),
                Text(value.toString(), style: TextStyle(fontSize: 14.sp, color: color, fontWeight: FontWeight.w500),)
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SfLinearGauge(
                    orientation: LinearGaugeOrientation.horizontal,
                    axisTrackStyle: LinearAxisTrackStyle(
                        thickness: 8.w,
                        borderColor: Colors.grey.shade500,
                        color: color.withAlpha(60),
                        edgeStyle: LinearEdgeStyle.bothCurve),
                    minimum: 0,
                    maximum: max(maximum.toDouble(), 1),
                    showLabels: false,
                    showTicks: false,
                    animateAxis: false,
                    barPointers: [
                      LinearBarPointer(
                        thickness: 8.w,
                        color: color,
                        edgeStyle: LinearEdgeStyle.bothCurve,
                        value: value.toDouble(),
                      )
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
