import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';
import 'package:work_hu/features/home/widgets/status_row.dart';
import 'package:work_hu/features/utils.dart';

import '../../teams/data/model/team_model.dart';

class Pace3StatusView extends StatelessWidget {
  const Pace3StatusView({super.key, required this.teams, required this.teamRounds});

  final List<TeamModel> teams;
  final List<TeamRoundModel> teamRounds;

  @override
  Widget build(BuildContext context) {
    teamRounds.sort((a, b) => b.teamRoundStatus.compareTo(a.teamRoundStatus));
    return ListView(
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: teams.length,
            itemBuilder: (context, index) {
              var team = teams.firstWhere((t) => t == teamRounds[index].team);
              var color = Color(int.parse("0x${team.color}"));

              var tr = teamRounds[index];
              var paymentsMax = teamRounds.map((tr) => tr.payments).reduce(max);
              var hoursMax = teamRounds.map((tr) => tr.teamHours).reduce(max);
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.sp, right: 8.sp, top: 16.sp),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.sp),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(int.parse("0x${team.startColor}")),
                            Color(int.parse("0x${team.endColor}")),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            style: ListTileStyle.list,
                            tileColor: Colors.transparent,
                            leading: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  width: 40.sp,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withAlpha(60)),
                                ),
                                Image.asset(
                                  team.iconAssetPath.toString(),
                                  color: color,
                                ),
                              ],
                            ),
                            title: Text(
                              team.teamName,
                              style: TextStyle(color: color, fontSize: 20.sp, fontWeight: FontWeight.w900),
                            ),
                            subtitle: Text(
                              "home_status_points".i18n([(Utils.percentFormat.format(tr.teamRoundStatus))]),
                              style: TextStyle(fontSize: 14.sp, color: color),
                            ),
                          ),
                          StatusRow(
                              statName: "home_status_on_track".i18n(),
                              value: tr.onTrack,
                              maximum: tr.maxTeamRoundCoins,
                              color: color),
                          StatusRow(statName: "home_status_hours".i18n(), value: tr.teamHours, maximum: hoursMax, color: color),
                          StatusRow(
                              statName: "home_status_payments".i18n(), value: tr.payments, maximum: paymentsMax, color: color)
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      child: Material(
                        elevation: 2.sp,
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(index == 0
                                      ? 0xFFFFD700
                                      : index == 1
                                          ? 0xFFC0C0C0
                                          : 0xFFCD7F32),
                                  Color(index == 0
                                      ? 0xFFFFA500
                                      : index == 1
                                          ? 0xFFA9A9A9
                                          : 0xFFA0522D),
                                ],
                                tileMode: TileMode.decal,
                              )),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(12.sp),
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              );
            }),
        Container(
          decoration: BoxDecoration(color: AppColors.white.withAlpha(70), borderRadius: BorderRadius.all(Radius.circular(8.sp))),
          margin: EdgeInsets.all(8.sp),
          padding: EdgeInsets.all(8.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "home_status_sum".i18n(),
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              Material(
                elevation: 0.sp,
                color: Colors.transparent,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: teams.length,
                  itemBuilder: (BuildContext context, int index) {
                    var team = teams[index];
                    var color = Color(int.parse("0x${team.color}"));
                    var endColor = Color(int.parse("0x${team.startColor}"));
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.sp),
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.sp))),
                        style: ListTileStyle.list,
                        tileColor: endColor.withAlpha(50),
                        leading: Container(
                          width: 40.sp,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(int.parse("0x${team.startColor}")),
                                  Color(int.parse("0x${team.endColor}")),
                                ],
                                tileMode: TileMode.decal,
                              )),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(12.sp),
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          team.teamName,
                          style: TextStyle(color: color, fontWeight: FontWeight.w900),
                        ),
                        trailing: Text(team.coins.toString(),
                            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                        subtitle: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SfLinearGauge(
                                    orientation: LinearGaugeOrientation.horizontal,
                                    axisTrackStyle: LinearAxisTrackStyle(
                                        thickness: 8.w,
                                        borderColor: Colors.transparent,
                                        color: Colors.grey.shade400,
                                        edgeStyle: LinearEdgeStyle.bothCurve),
                                    minimum: 0,
                                    maximum: teams.map((t) => t.coins).reduce((a, b) => a + b),
                                    showLabels: false,
                                    showTicks: false,
                                    animateAxis: false,
                                    animateRange: false,
                                    ranges: [
                                      LinearGaugeRange(
                                          startValue: 0,
                                          endValue: team.coins,
                                          startWidth: 8.sp,
                                          endWidth: 8.sp,
                                          position: LinearElementPosition.cross,
                                          edgeStyle: LinearEdgeStyle.bothCurve,
                                          shaderCallback: (r) => LinearGradient(colors: [
                                                Color(int.parse("0x${team.startColor}")),
                                                Color(int.parse("0x${team.endColor}")),
                                              ]).createShader(r))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
