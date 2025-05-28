import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';
import 'package:work_hu/features/home/widgets/pace_3_status_view.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

class StatusView extends ConsumerWidget {
  const StatusView({super.key, required this.teams, required this.teamRounds});

  final List<TeamModel> teams;
  final List<TeamRoundModel> teamRounds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber;
    List<LinearWidgetPointer> linearGauges = [];
    var rangeGauges = <LinearGaugeRange>[];
    if (teamRounds.isNotEmpty && teams.isNotEmpty) {
      linearGauges = teamRounds.where((tr) => tr.round.roundNumber != currentRound && tr.round.winnerTeam == tr.team).map((tr) {
        return LinearWidgetPointer(
          value: tr.round.roundNumber.toDouble(),
          position: tr.round.roundNumber % 2 == 0 ? LinearElementPosition.outside : LinearElementPosition.inside,
          child: Image.asset(
            tr.team.iconAssetPath.toString(),
            color: Color(int.parse("0x${tr.team.color}")),
          ),
        );
      }).toList();

      rangeGauges = teamRounds.where((tr) => tr.round.roundNumber != currentRound && tr.round.winnerTeam == tr.team).map((tr) {
        return LinearGaugeRange(
            startValue: tr.round.roundNumber.toDouble() - 1,
            endValue: tr.round.roundNumber.toDouble(),
            startWidth: 8.sp,
            endWidth: 8.sp,
            position: LinearElementPosition.cross,
            edgeStyle: tr.round.roundNumber == 19 ? LinearEdgeStyle.startCurve : LinearEdgeStyle.bothFlat,
            color: Color(int.parse("0x${tr.team.color}")));
      }).toList();

      linearGauges.addAll(List<LinearWidgetPointer>.generate(8 - linearGauges.length, (g) {
        var num = teamRounds.last.round.roundNumber + g + linearGauges.length;
        return LinearWidgetPointer(
          value: num.toDouble(),
          position: num % 2 == 0 ? LinearElementPosition.outside : LinearElementPosition.inside,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade400,
            ),
            child: Padding(
              padding: EdgeInsets.all(8.sp),
              child: Text(
                "?",
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              ),
            ),
          ),
        );
      }));
      var maxi = teamRounds.where((tr) => tr.round.roundNumber == currentRound).map((tr) => tr.teamRoundStatus).reduce(max);
      rangeGauges.add(LinearGaugeRange(
          startValue: currentRound - 1,
          endValue: currentRound.toDouble(),
          startWidth: 8.sp,
          endWidth: 8.sp,
          position: LinearElementPosition.cross,
          edgeStyle: LinearEdgeStyle.endCurve,
          color: Color(int.parse("0x${teamRounds.firstWhere((tr) => tr.teamRoundStatus == maxi).team.color}"))));
    }

    return teams.isNotEmpty && teamRounds.isNotEmpty && currentRound != 0
        ? Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Row(
              //   children: [
              //     TextButton(
              //         onPressed: () => ref.watch(localeProvider.notifier).changeLocale(),
              //         child: Text(ref.watch(localeProvider)?.languageCode ?? ""))
              //   ],
              // ),
              Row(
                children: [
                  Expanded(
                    child: SfLinearGauge(
                      orientation: LinearGaugeOrientation.horizontal,
                      axisTrackStyle: LinearAxisTrackStyle(
                          thickness: 8.w,
                          borderColor: Colors.grey.shade500,
                          color: Colors.grey.shade500,
                          edgeStyle: LinearEdgeStyle.bothCurve),
                      minimum: teamRounds.last.round.roundNumber.toDouble() - 1,
                      maximum: teamRounds.last.round.roundNumber.toDouble() + 7,
                      showLabels: false,
                      showTicks: true,
                      animateAxis: false,
                      markerPointers: linearGauges,
                      ranges: rangeGauges,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Pace3StatusView(
                    teams: teams, teamRounds: teamRounds.where((tr) => tr.round.roundNumber == currentRound).toList()),
              ),
            ],
          )
        : Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    height: 400.sp,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp)),
                  );
                }));
  }
}
