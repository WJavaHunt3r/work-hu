import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/widgets/base_tab_bar.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/widgets/profile_grid.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/utils.dart';

class TabView extends ConsumerWidget {
  const TabView({super.key, required this.user, required this.userRounds});

  final UserModel user;
  final List<UserRoundModel> userRounds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber;
    return userRounds.isEmpty
        ? const SizedBox()
        : DefaultTabController(
            length: currentRound.toInt() + 1,
            initialIndex: currentRound == 0 ? 0 : currentRound.toInt() - 1,
            child: BaseTabView(
              tabs: createTabs(userRounds),
              tabViews: createTabView(userRounds),
            ));
  }

  createUserRoundModel(List<UserRoundModel> userRounds) {
    return UserRoundModel(
        round: Utils.createEmptyRound(),
        user: user,
        myShareOnTrackPoints: false,
        samvirkOnTrackPoints: false,
        samvirkPayments: userRounds.isNotEmpty
            ? userRounds.map((e) => e.samvirkPayments).reduce((value, element) => value + element)
            : 0,
        bmmperfectWeekPoints: userRounds.isNotEmpty
            ? userRounds.map((e) => e.bmmperfectWeekPoints).reduce((value, element) => value + element)
            : 0,
        samvirkPoints: userRounds.isNotEmpty
            ? userRounds.map((e) => e.samvirkPoints).reduce((value, element) => value + element)
            : 0,
        roundPoints: userRounds.isNotEmpty
            ? userRounds.map((e) => e.roundPoints).reduce((value, element) => value + element)
            : 0);
  }

  num countItems(List<UserRoundModel> items) {
    var count = items.map((e) => e.round.roundNumber).toList().isNotEmpty
        ? items.map((e) => e.round.roundNumber).toSet().toList().length
        : 0;

    return count;
  }

  List<Tab> createTabs(List<UserRoundModel> items) {
    var count = countItems(items);
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
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
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

  List<Widget> createTabView(List<UserRoundModel> items) {
    var count = countItems(items);
    var list = <Widget>[];
    for (int i = 1; i <= count; i++) {
      list.add(ProfileGrid(user: user, userRoundModel: items[i - 1]));
    }
    list.add(ProfileGrid(user: user, userRoundModel: createUserRoundModel(items)));

    return list;
  }
}
