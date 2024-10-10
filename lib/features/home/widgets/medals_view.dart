import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';
import 'package:work_hu/features/home/widgets/medal_place_holder.dart';
import 'package:work_hu/features/home/widgets/round_winner_medal.dart';
import 'package:work_hu/features/utils.dart';

class MedalsView extends ConsumerWidget {
  const MedalsView({required this.buk, required this.samvirk, required this.rounds, super.key});

  final TeamRoundModel buk;
  final TeamRoundModel samvirk;
  final List<TeamRoundModel> rounds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 30.sp),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.orange, spreadRadius: 8.sp, blurRadius: 10.sp, blurStyle: BlurStyle.normal)
            ],
            borderRadius: BorderRadius.circular(12.sp),
            color: const Color(0xFF5C4033),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text("PACE",
                style: TextStyle(fontFamily: "Good-Timing", color: Colors.orange, fontSize: 70.sp, height: 0.7.sp)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "GOLDEN\nGENERATION",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Good-Timing", fontSize: 16.sp, overflow: TextOverflow.clip, color: Colors.white),
                ),
                Text(
                  "Shooting\nStars",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Good-Timing", fontSize: 16.sp, overflow: TextOverflow.ellipsis, color: Colors.white),
                ),
              ],
            ),
            createMonthlyWinnerRows(rounds, context)
          ]),
        ));
  }

  createMonthlyWinnerRows(List<TeamRoundModel> rounds, BuildContext context) {
    var rows = <Widget>[];
    for (var i = 8; i <= 12; i++) {
      TeamRoundModel? winner;
      var monthlyRounds = rounds.where((r) => r.round.startDateTime.month == i).toList();
      if (monthlyRounds.isNotEmpty && monthlyRounds.first.round.freezeDateTime.compareTo(DateTime.now()) < 0) {
        monthlyRounds.sort((a, b) => b.teamRoundStatus.compareTo(a.teamRoundStatus));
        winner = monthlyRounds.first;
      }
      rows.add(Padding(
        padding: EdgeInsets.all(4.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            winner == null || winner.team.teamName.toLowerCase() == "team samvirk"
                ? const MedalPlaceHolder()
                : RoundWinnerMedal(month: Utils.getMonthFromDate(monthlyRounds.first.round.startDateTime, context)),
            Text(Utils.getMonthFromDate(DateTime(2024, i, 1), context).toUpperCase(),
                style: TextStyle(fontFamily: "Good-Timing", color: Colors.white, fontSize: 10.sp)),
            winner == null || winner.team.teamName.toLowerCase() != "team samvirk"
                ? const MedalPlaceHolder()
                : RoundWinnerMedal(month: Utils.getMonthFromDate(monthlyRounds.first.round.startDateTime, context)),
          ],
        ),
      ));
    }
    return Expanded(child: ListView(children: rows));
  }
}
