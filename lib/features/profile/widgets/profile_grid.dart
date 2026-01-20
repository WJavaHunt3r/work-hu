import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/info_widget.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_page.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/utils.dart';

class ProfileGrid extends StatelessWidget {
  const ProfileGrid({required this.userRoundModel, super.key, required this.userStatus});

  final UserRoundModel userRoundModel;
  final UserStatusModel userStatus;

  @override
  Widget build(BuildContext context) {
    UserModel? user = userStatus.user;
    var isOnTrack = userStatus.status * 100 >= (userRoundModel.round.localMyShareGoal ?? userRoundModel.round.myShareGoal);
    var color = isOnTrack
        ? const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFffd700), // gold
                Color(0xFFdaa520), // goldenrod
                Color(0xFFb8860b), // darkgoldenrod
              ],
              stops: [0.1, 0.5, 0.9],
            ),
          )
        : null;
    return Row(
      children: [
        Expanded(
            child: InfoCard(
                decoration: color,
                height: 110.sp,
                padding: 10.sp,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text("${Utils.percentFormat.format(userStatus.status * 100)}%",
                              style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800)),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: InfoWidget(
                              infoText: "profile_myshare_status_info".i18n(),
                              shadowColor: Theme.of(context).colorScheme.shadow,
                              iconData: Icons.info_outline,
                              iconColor: Theme.of(context).colorScheme.primary,
                            )),
                        // Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Image(
                        //       image: AssetImage(
                        //         isOnTrack
                        //             ? "assets/img/PACE_Coin_Buk_50a_Static.png"
                        //             : "assets/img/PACE_Coin_Blank_Static.png",
                        //       ),
                        //       fit: BoxFit.fitWidth,
                        //       height: 18.sp,
                        //     ))
                      ],
                    ),
                    Text(
                        "profile_myshare_status".i18n([Utils.percentFormat2Digits.format(userRoundModel.round.localMyShareGoal)]),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600)),
                  ],
                ),
                onTap: () => showGeneralDialog(
                    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                    barrierColor: AppColors.primary,
                    transitionDuration: const Duration(milliseconds: 200),
                    context: context,
                    pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                      return MyShareStatusPage(
                          userGoalRound: UserGoalUserRoundModel(userStatus: userStatus, round: userRoundModel.round));
                    }))),
        SizedBox(
          width: 4.sp,
        ),
        Expanded(
          child: InfoCard(
              height: 110.sp,
              padding: 10.sp,
              decoration: color,
              onTap: () {
                context.push("/profile/userPoints/${user.id}");
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
                            ],
                          )),
                      Align(
                          alignment: Alignment.topRight,
                          child: InfoWidget(
                            infoText: "profile_monthly_credits_info".i18n(),
                            iconData: Icons.info_outline,
                            shadowColor: Theme.of(context).colorScheme.shadow,
                            iconColor: Theme.of(context).colorScheme.primary,
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "profile_points".i18n([(Math.max(userRoundModel.roundMyShareGoal, 0)).toString()]),
                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
