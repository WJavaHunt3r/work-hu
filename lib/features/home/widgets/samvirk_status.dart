import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';

class SamvirkStatus extends ConsumerWidget {
  SamvirkStatus({required this.itemCount, required this.teamRounds, required this.currentRound, super.key});

  final num itemCount;

  final List<TeamRoundModel> teamRounds;
  final num currentRound;
  final NumberFormat numberFormat = NumberFormat("#,###.#");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTeamRounds =
        ref.watch(teamRoundDataProvider).teams.where((element) => element.round.roundNumber == currentRound);
    var samvirkStatus = currentTeamRounds.isEmpty
        ? 0.0
        : ref
            .watch(teamRoundDataProvider)
            .teams
            .where((element) => element.round == currentTeamRounds.first.round)
            .map((e) => e.samvirkPayments)
            .reduce((value, element) => value + element);
    var maximum = currentTeamRounds.isEmpty ? 10.0 : currentTeamRounds.first.round.samvirkChurchGoal.toDouble();
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
                      itemCount.toDouble() == 0 ? 0.0.toString() : numberFormat.format(samvirkStatus).toString(),
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
                                  thickness: 25.sp, color: AppColors.primary100, edgeStyle: LinearEdgeStyle.bothCurve),
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
                              value: currentTeamRounds.isEmpty ? 0.0 : samvirkStatus,
                            ),
                          ]))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text("0"), Text(numberFormat.format(maximum))],
                )
              ])),
        ));
  }
}
