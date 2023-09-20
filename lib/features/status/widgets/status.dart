import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/status/providers/team_provider.dart';

import '../data/model/team_model.dart';

class Status extends ConsumerWidget {
  const Status({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(teamDataProvider).isLoading
        ? const Center(child: CircularProgressIndicator())
        : StatusView(teams: ref.watch(teamDataProvider).teams);
  }
}

class StatusView extends StatelessWidget {
  const StatusView({super.key, required this.teams});

  final List<TeamModel> teams;

  @override
  Widget build(BuildContext context) {
    var max = 0.0;
    for (var t in teams) {
      if (t.points > max) max = t.points;
    }
    return Column(
      children: [
        Expanded(flex: 2, child: SizedBox(height: 20.sp, child: Center(child: Text("Last updated: 2023.09.15."),))),
        Expanded(flex: 20, child: SizedBox(
          child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: Center(
                  child: ListView.builder(
                      itemCount: teams.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return StatusRow(
                          logoColor: teams[index].color,
                          value: teams[index].points,
                          maximum: (max / 50) + 50,
                        );
                      }))),
        ))
      ],
    );
  }
}

class StatusRow extends StatelessWidget {
  const StatusRow({super.key, required this.logoColor, required this.value, required this.maximum});

  final String logoColor;
  final double value;
  final double maximum;

  @override
  Widget build(BuildContext context) {
    final Color color = logoColor == "BLUE"
        ? AppColors.teamBlue
        : logoColor == "GREEN"
            ? AppColors.teamGreen
            : logoColor == "RED"
                ? AppColors.teamRed
                : AppColors.teamOrange;
    return SizedBox(
        height: 90.sp,
        child: Padding(
            padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 10.sp, bottom: 10.sp),
            child: Row(
              children: [
                Image(
                  image: AssetImage("assets/logos/WORK_${logoColor}_black_Vácduka.png"),
                  fit: BoxFit.contain,
                  height: 90.sp,
                ),
                SizedBox(
                  width: 10.sp,
                ),
                Expanded(
                    child: SfLinearGauge(
                        orientation: LinearGaugeOrientation.horizontal,
                        axisTrackStyle: LinearAxisTrackStyle(
                            thickness: 50.sp, color: Colors.transparent, edgeStyle: LinearEdgeStyle.bothCurve),
                        minimum: 0,
                        maximum: maximum,
                        showLabels: false,
                        showTicks: false,
                        markerPointers: null,
                        barPointers: [
                      LinearBarPointer(
                        thickness: 30.sp,
                        color: color,
                        edgeStyle: LinearEdgeStyle.endCurve,
                        value: value,
                      )
                    ])),
                Text(
                  value.toInt().toString(),
                  style: TextStyle(color: color, fontSize: 25.sp),
                )
              ],
            )));
  }
}
