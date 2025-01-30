import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/utils.dart';

class SamvirkStatus extends ConsumerWidget {
  SamvirkStatus({required this.itemCount, required this.teamRounds, required this.currentRoundNumber, super.key});

  final num itemCount;

  final List<TeamRoundModel> teamRounds;
  final num currentRoundNumber;
  final NumberFormat numberFormat = NumberFormat("#,###.#");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var currentTeamRounds =
    //     ref.watch(teamRoundDataProvider).teams.where((element) => element.round.roundNumber == currentRoundNumber);
    // var samvirkStatus = currentTeamRounds.isEmpty
    //     ? 0.0
    //     : ref.watch(teamRoundDataProvider).teams.where((element) => element.round == currentTeamRounds.first.round);
    // RoundModel? currentRound = currentTeamRounds.isEmpty ? null : currentTeamRounds.first.round;
    var maximum = 10.0  ;//currentTeamRounds.isEmpty ? 10.0 : currentTeamRounds.first.round.samvirkChurchGoal.toDouble();
    return Padding(
        padding: EdgeInsets.only(bottom: 8.sp),
        child: Card(
          child: Padding(
              padding: EdgeInsets.all(8.sp),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Samvirk Status:"),
                    Text(
                      0.toString(),
                      //itemCount.toDouble() == 0 ? 0.0.toString() : Utils.creditFormatting(samvirkStatus).toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: SfLinearGauge(
                              orientation: LinearGaugeOrientation.horizontal,
                              axisTrackStyle: LinearAxisTrackStyle(
                                  thickness: 25.sp, color: AppColors.gray100, edgeStyle: LinearEdgeStyle.bothCurve),
                              minimum: 0,
                              maximum: maximum,
                              numberFormat: numberFormat,
                              showLabels: false,
                              showTicks: false,
                              markerPointers: null,
                              barPointers: [
                            LinearBarPointer(
                                thickness: 25.sp,
                                color: AppColors.primary,
                                edgeStyle: LinearEdgeStyle.bothCurve,
                                value: 0 //currentTeamRounds.isEmpty ? 0.0 : samvirkStatus,
                                ),
                          ]))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text("0"), Text(Utils.creditFormatting(maximum))],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(currentRound != null ? Utils.dateToString(currentRound.startDateTime) : ""),
                    // Text(currentRound != null ? Utils.dateToString(currentRound.endDateTime) : ""),
                  ],
                )
              ])),
        ));
  }
}
