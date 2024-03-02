import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/utils.dart';

class MyShareStatusLayout extends StatelessWidget {
  const MyShareStatusLayout({super.key, required this.userGoalRound});

  final UserGoalUserRoundModel userGoalRound;

  @override
  Widget build(BuildContext context) {
    var userGoal = userGoalRound.goal;
    var user = userGoalRound.user;
    var currentRound = userGoalRound.userRound.round;
    var userStatus = user.currentMyShareCredit / userGoal.goal * 100;
    var isOnTrack = userGoalRound.isOnTrack();
    var toOnTrack =
        Utils.creditFormatting((userGoal.goal) * (currentRound.myShareGoal) / 100 - user.currentMyShareCredit);
    return Column(children: [
      SfRadialGauge(
        enableLoadingAnimation: true,
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: userGoal.goal.toDouble(),
            axisLineStyle: AxisLineStyle(thickness: 15.sp, cornerStyle: CornerStyle.bothCurve),
            showLabels: false,
            showTicks: false,
            pointers: [
              RangePointer(
                value: user.currentMyShareCredit.toDouble(),
                cornerStyle: CornerStyle.bothCurve,
                color: AppColors.primary,
                width: 15.sp,
              ),
              MarkerPointer(
                value: (currentRound.myShareGoal) / 100 * (userGoal.goal),
              )
            ],
            annotations: [
              GaugeAnnotation(
                  widget: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${Utils.percentFormat.format(userStatus)} %",
                    style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                  Text(
                    "${Utils.creditFormatting(user.currentMyShareCredit)} Ft",
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                  Text(
                    "Goal: ${Utils.creditFormatting(userGoal.goal)} Ft",
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ],
              ))
            ],
          )
        ],
      ),
      Row(
        children: [
          Expanded(
              child: Text(
            isOnTrack ? "You are On Track" : "$toOnTrack Ft to be On Track",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w800, color: AppColors.primary),
          )),
        ],
      )
    ]);
  }
}
