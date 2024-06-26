import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/base_tab_bar.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';
import 'package:work_hu/features/home/widgets/samvirk_status.dart';
import 'package:work_hu/features/home/widgets/status_row.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/utils.dart';

class StatusView extends ConsumerWidget {
  const StatusView({super.key, required this.teamRounds});

  final List<TeamRoundModel> teamRounds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber;
    return teamRounds.isNotEmpty
        ? DefaultTabController(
            length: currentRound.toInt() + 1,
            initialIndex: currentRound == 0 ? 0 : currentRound.toInt() - 1,
            child: BaseTabView(
                tabs: createTabs(teamRounds, currentRound), tabViews: createTabView(teamRounds, ref, currentRound)),
          )
        : const SizedBox();
  }

  num countItems(List<TeamRoundModel> items) {
    var count = items.map((e) => e.round.roundNumber).toList().isNotEmpty
        ? items.map((e) => e.round.roundNumber).toSet().toList().length
        : 0;

    return count;
  }

  List<Tab> createTabs(List<TeamRoundModel> items, num currentRound) {
    var count = currentRound;
    var list = <Tab>[];
    for (num i = 1; i <= count; i++) {
      list.add(Tab(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Text(
            "round_number".i18n([i.toString()]),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ))
        ],
      )));
    }
    list.add(Tab(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("total".i18n())],
      ),
    ));
    return list;
  }

  List<Widget> createTabView(List<TeamRoundModel> items, WidgetRef ref, num currentRound) {
    var max = 0.0;
    for (var t in teamRounds) {
      if (t.teamPoints > max) max = t.teamPoints;
    }
    var count = currentRound;
    var list = <Widget>[];
    for (int i = 1; i <= count; i++) {
      var currentRounds = teamRounds.where((element) => element.round.roundNumber == i);
      list.add(RefreshIndicator(
          onRefresh: () async => ref.watch(teamRoundDataProvider.notifier).getTeamRounds(),
          child: BaseListView(
              itemCount: currentRounds.length,
              itemBuilder: (context, index) {
                var team = currentRounds.toList()[index];
                if (team.teamPoints == 0.0) {
                  return const SizedBox();
                }
                return ListCard(
                    isLast: currentRounds.length - 1 == index,
                    index: index,
                    child: StatusRow(
                      logoColor: team.team.color,
                      value: team.teamPoints,
                      maximum: (currentRounds.first.teamPoints / 50.0) * 55,
                    ));
              },
              children: [
                currentRounds.isEmpty
                    ? const SizedBox()
                    : SamvirkStatus(itemCount: count, teamRounds: teamRounds, currentRoundNumber: i)
              ])));
    }
    var totalTeamRounds = createSumTeamRound(teamRounds);
    totalTeamRounds.sort((a, b) => b.teamPoints.compareTo(a.teamPoints));
    list.add(BaseListView(
        itemBuilder: (context, index) {
          var current = totalTeamRounds[index];
          return ListCard(
              isLast: totalTeamRounds.length - 1 == index,
              index: index,
              child: StatusRow(
                logoColor: current.team.color,
                value: current.teamPoints,
                maximum: ((totalTeamRounds[0].teamPoints / 50.0)) * 55,
              ));
        },
        itemCount: totalTeamRounds.length,
        children: const []));

    return list;
  }

  List<TeamRoundModel> createSumTeamRound(List<TeamRoundModel> teamRounds) {
    var colors = teamRounds.map((e) => e.team.color).toSet().toList();
    teamRounds.map((e) => e.teamPoints);
    List<TeamRoundModel> totalTeamRounds = <TeamRoundModel>[];
    for (var e in colors) {
      var sum = teamRounds
          .where((t) => t.team.color == e)
          .map((e) => e.teamPoints)
          .reduce((value, element) => value + element);
      totalTeamRounds.add(TeamRoundModel(
          id: 0,
          samvirkPayments: 0,
          round: Utils.createEmptyRound(),
          team: teamRounds.firstWhere((element) => element.team.color == e).team,
          teamPoints: sum));
    }
    return totalTeamRounds;
  }
}
