import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/widgets/profile_grid.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/utils.dart';

class ProfileTabView extends ConsumerWidget {
  const ProfileTabView(
      {super.key, required this.userRounds, this.userStatus, this.titleText});

  final List<UserRoundModel> userRounds;
  final UserStatusModel? userStatus;
  final String? titleText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber;
    if (currentRound == 0) return const SizedBox();
    var item =
        userRounds.firstWhere((e) => e.round.roundNumber == currentRound);
    var date = item.round.startDateTime;

    String formatted = Utils.getMonthFromDate(date, context);
    return userRounds.isEmpty || currentRound == 0
        ? const SizedBox()
        : Column(
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
                        titleText ?? formatted,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: AppColors.white, fontSize: 22.sp),
                      ),
                    ),
                  ),
                ],
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return ProfileGrid(
                      userRoundModel: item, userStatus: userStatus);
                },
              )
            ],
          );
  }

  Consumer createTabView(List<UserRoundModel> items, num currentRound) {
    var item = items.firstWhere((e) => e.round.roundNumber == currentRound);
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return ProfileGrid(
            userRoundModel: item,
            userStatus: ref.watch(profileDataProvider).userStatus);
      },
    );
  }
}
