import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/style/app_colors.dart';

class MyShareStatusLayout extends StatelessWidget {
  const MyShareStatusLayout({super.key, required this.userGoalRound});

  final UserGoalUserRoundModel userGoalRound;

  @override
  Widget build(BuildContext context) {
    var userStatusModel = userGoalRound.userStatus;
    var user = userGoalRound.userStatus.user;

    var currentRound = userGoalRound.round;
    var userStatus = userStatusModel.status * 100;
    var isOnTrack = userStatusModel.onTrack;
    var toOnTrack = Utils.creditFormatting(
        (userStatusModel.goal) * (currentRound.myShareGoal) / 100 -
            userStatusModel.transactions);
    return Column(children: [
      Padding(
          padding: EdgeInsets.symmetric(vertical: 12.sp),
          child: Text(
            user.getFullName(),
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w800),
          )),
      SfRadialGauge(
        enableLoadingAnimation: true,
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: userStatusModel.goal.toDouble(),
            axisLineStyle: AxisLineStyle(
                thickness: 15.sp, cornerStyle: CornerStyle.bothCurve),
            showLabels: false,
            showTicks: false,
            pointers: [
              RangePointer(
                value: userStatusModel.transactions.toDouble(),
                cornerStyle: CornerStyle.bothCurve,
                width: 15.sp,
              ),
              MarkerPointer(
                color: AppColors.teamOrange,
                value:
                    (currentRound.myShareGoal) / 100 * (userStatusModel.goal),
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
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "${Utils.creditFormatting(userStatusModel.transactions)} Ft",
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "myshare_status_goal"
                        .i18n([Utils.creditFormatting(userStatusModel.goal)]),
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
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
            isOnTrack
                ? "myshare_status_your_ontrack".i18n()
                : "myshare_status_to_be_ontrack".i18n([toOnTrack.toString()]),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w800),
          )),
        ],
      )
    ]);
  }
}
