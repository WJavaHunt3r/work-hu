import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/widgets/base_tab_bar.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/widgets/profile_grid.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/utils.dart';

class ProfileTabView extends ConsumerWidget {
  const ProfileTabView({super.key, required this.userRounds});

  final List<UserRoundModel> userRounds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber;
    return userRounds.isEmpty || currentRound == 0
        ? const SizedBox()
        : DefaultTabController(
            length: 1, //currentRound.toInt() + 1,
            initialIndex: 0, // currentRound == 0 ? 0 : currentRound.toInt() - 1,
            child: BaseTabView(
              tabs: createTabs(userRounds, currentRound, context),
              tabViews: createTabView(userRounds, currentRound),
            ));
  }

  List<Tab> createTabs(List<UserRoundModel> items, num currentRound, BuildContext context) {
    var list = <Tab>[];
    var item = items.firstWhere((e) => e.round.roundNumber == currentRound);
    var date = item.round.startDateTime;

    String formatted = Utils.getMonthFromDate(date, context);
    list.add(Tab(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(formatted)],
      ),
    ));
    return list;
  }

  List<Widget> createTabView(List<UserRoundModel> items, num currentRound) {
    var list = <Widget>[];
    var item = items.firstWhere((e) => e.round.roundNumber == currentRound);
    list.add(Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return ProfileGrid(userRoundModel: item, goal: ref.watch(profileDataProvider).userGoal);
      },
    ));

    return list;
  }
}
