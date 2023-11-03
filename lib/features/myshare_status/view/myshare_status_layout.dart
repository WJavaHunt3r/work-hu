import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/utils.dart';

class MyShareStatusLayout extends ConsumerWidget {
  const MyShareStatusLayout({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentRound = ref
        .watch(roundDataProvider)
        .rounds
        .firstWhere((element) => element.roundNumber == ref.watch(roundDataProvider).currentRoundNumber);
    var userStatus = user.currentMyShareCredit / user.goal * 100;
    var isOnTrack = currentRound.myShareGoal <= userStatus;
    var toOnTrack = Utils.creditFormat.format(user.goal * currentRound.myShareGoal / 100 - user.currentMyShareCredit);
    return Column(children: [
      SfRadialGauge(
        enableLoadingAnimation: true,
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: user.goal.toDouble(),
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
                value: currentRound.myShareGoal / 100 * user.goal,
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
                    "${Utils.creditFormat.format(user.currentMyShareCredit)} Ft",
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
