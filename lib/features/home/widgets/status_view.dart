import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';
import 'package:work_hu/features/home/widgets/status_chart.dart';
import 'package:work_hu/features/home/widgets/status_row.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/utils.dart';

class StatusView extends ConsumerWidget {
  const StatusView({super.key, required this.teams});

  final List<TeamModel> teams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber;
    return teams.isNotEmpty && currentRound != 0
        ? Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.sp),
                      padding: EdgeInsets.symmetric(vertical: 6.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.sp),
                          color: AppColors.primary),
                      child: Text(
                        "profile_week_number".i18n([currentRound.toString()]),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: AppColors.white, fontSize: 22.sp, fontFamily: "Good-Timing"),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                    child: StatusChart(
                  teams: teams,
                )),
              ),
            ],
          )
        : const SizedBox();
  }

  List<Tab> createTabs(num currentRound, context) {
    var list = <Tab>[];
    list.add(Tab(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Text(
          "profile_week_number".i18n([currentRound.toString()]),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: "Good-Timing"),
        ))
      ],
    )));

    return list;
  }
}
