import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/widgets/base_tab_bar.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';
import 'package:work_hu/features/home/widgets/status_row.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/utils.dart';

class StatusView extends ConsumerWidget {
  const StatusView({super.key, required this.teamRounds});

  final List<TeamRoundModel> teamRounds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber;
    return teamRounds.isNotEmpty && currentRound != 0
        ? DefaultTabController(
            length: 2,
            initialIndex: currentRound == 0 ? 0 : currentRound.toInt() - 1,
            child: BaseTabView(
                tabs: createTabs(teamRounds, currentRound, context),
                tabViews: createTabView(teamRounds, ref, currentRound)),
          )
        : const SizedBox();
  }

  List<Tab> createTabs(List<TeamRoundModel> items, num currentRound, context) {
    String formated = Utils.getMonthFromDate(DateTime.now(), context);

    var list = <Tab>[];
    list.add(Tab(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Text(
          formated,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: "Good-Timing"),
        ))
      ],
    )));

    list.add(Tab(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("home_medals".i18n(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: "Good-Timing"))
        ],
      ),
    ));
    return list;
  }

  List<Widget> createTabView(List<TeamRoundModel> items, WidgetRef ref, num currentRound) {
    var list = <Widget>[];
    var currentRounds = teamRounds.where((element) => element.round.roundNumber == currentRound);
    var buk = currentRounds.firstWhere((e) => e.team.teamName == "Team BUK");
    var samvirk = currentRounds.firstWhere((e) => e.team.teamName == "Team Samvirk");

    list.add(Row(
      children: [
        _buildStatusGridView(buk, LinearElementPosition.outside),
        _buildStatusGridView(samvirk, LinearElementPosition.inside)
      ],
    ));

    list.add(const Center(child: Text("Hamarosan érkezik", style: const TextStyle(fontFamily: "Good-Timing"))));

    return list;
  }

  Widget _buildStatusGridView(TeamRoundModel team, LinearElementPosition position) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Center(
              child: Text(
            "${Utils.percentFormat.format(team.teamRoundStatus * 100)}%",
            style: TextStyle(fontFamily: "Good-Timing", fontSize: 30.sp),
          )),
        ),
        Expanded(
            flex: 7,
            child: Center(
              child: StatusColumn(
                teamName: team.team.teamName,
                value: team.teamRoundCoins,
                maximum: team.maxTeamRoundCoins,
                linearElementPosition: position,
              ),
            )),
        Center(
            child: Text(
          team.team.teamName,
          maxLines: 1,
          style: TextStyle(fontFamily: "Good-Timing", fontSize: 25, overflow: TextOverflow.ellipsis),
        )),
        const SizedBox(height: 10,)
      ],
    ));
  }
}
