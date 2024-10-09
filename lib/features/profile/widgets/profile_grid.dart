import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_page.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';
import 'package:work_hu/features/user_points/provider/user_points_providers.dart';
import 'package:work_hu/features/utils.dart';

class ProfileGrid extends ConsumerWidget {
  const ProfileGrid({required this.userRoundModel, super.key, required this.goal});

  final UserRoundModel userRoundModel;
  final GoalModel? goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel? user = goal?.user;
    var isOnTrack = goal != null && user!.currentMyShareCredit / goal!.goal * 100 > userRoundModel.round.myShareGoal;
    var isMonthlyOnTrack = goal != null && userRoundModel.roundCredits >= userRoundModel.roundMyShareGoal;
    return Row(
      children: [
        Expanded(
            child: user != null
                ? InfoCard(
                    height: 100.sp,
                    padding: 10.sp,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: goal == null
                                  ? Text("profile_no_goal".i18n())
                                  : Text(
                                      "${Utils.creditFormat.format(userRoundModel.user.currentMyShareCredit / goal!.goal * 100)}%",
                                      style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w800)),
                            ),
                            if (isOnTrack)
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Image(
                                    image: const AssetImage(
                                      "assets/img/PACE_Coin_Buk_50_Spin_540px.gif",
                                    ),
                                    fit: BoxFit.fitWidth,
                                    height: 15.sp,
                                  ))
                          ],
                        ),
                        Text("profile_myshare_status".i18n(),
                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    onTap: () => goal == null
                        ? null
                        : showGeneralDialog(
                            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                            barrierColor: AppColors.primary,
                            transitionDuration: const Duration(milliseconds: 200),
                            context: context,
                            pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                              return MyShareStatusPage(
                                  userGoalRound: UserGoalUserRoundModel(
                                      user: userRoundModel.user, goal: goal!, round: userRoundModel.round));
                            }))
                : const SizedBox()),
        SizedBox(
          width: 12.sp,
        ),
        Expanded(
          child: InfoCard(
              height: 100.sp,
              padding: 10.sp,
              onTap: () {
                ref.read(userPointsDataProvider.notifier).getTransactionItems();
                context
                    .push("/profile/userPoints")
                    .then((value) => ref.read(profileDataProvider.notifier).getUserInfo());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(Utils.creditFormatting(userRoundModel.roundCredits),
                                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800)),
                              Text(
                                "profile_monthly_payments_from"
                                    .i18n([Utils.creditFormatting(userRoundModel.roundMyShareGoal)]),
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                              )
                            ],
                          )),
                      if (isMonthlyOnTrack)
                        Align(
                            alignment: Alignment.topRight,
                            child: Image(
                              image: const AssetImage(
                                "img/PACE_Coin_Buk_50_Spin_540px.gif",
                              ),
                              fit: BoxFit.fitWidth,
                              height: 15.sp,
                            ))
                    ],
                  ),
                  Text(
                    "profile_monthly_payments".i18n(),
                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
