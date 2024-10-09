import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';
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
            child: Column(
              children: [
                TabBar(
                    unselectedLabelStyle: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.normal,
                        fontSize: 12.sp,
                        overflow: TextOverflow.ellipsis),
                    labelStyle: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        overflow: TextOverflow.ellipsis),
                    dividerColor: Colors.transparent,
                    labelPadding: EdgeInsets.all(0.sp),
                    splashBorderRadius: BorderRadius.all(Radius.circular(30.sp)),
                    padding: EdgeInsets.all(0.sp),
                    indicator: ShapeDecoration(
                      color: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.sp)),
                    ),
                    tabs: [createTabs(userRounds, currentRound, context)]),
                createTabView(userRounds, currentRound),
              ],
            ));
  }

  Tab createTabs(List<UserRoundModel> items, num currentRound, BuildContext context) {
    var item = items.firstWhere((e) => e.round.roundNumber == currentRound);
    var date = item.round.startDateTime;

    String formatted = Utils.getMonthFromDate(date, context);
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(formatted)],
      ),
    );
  }

  Consumer createTabView(List<UserRoundModel> items, num currentRound) {
    var item = items.firstWhere((e) => e.round.roundNumber == currentRound);
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return ProfileGrid(userRoundModel: item, goal: ref.watch(profileDataProvider).userGoal);
      },
    );
  }
}
