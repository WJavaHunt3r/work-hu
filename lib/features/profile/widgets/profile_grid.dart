import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_page.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';
import 'package:work_hu/features/user_points/provider/user_points_providers.dart';
import 'package:work_hu/features/utils.dart';

class ProfileGrid extends ConsumerWidget {
  const ProfileGrid({required this.user, required this.userRoundModel, super.key});

  final UserModel user;
  final UserRoundModel userRoundModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var goal = ref.watch(profileDataProvider).userGoal;
    final NumberFormat numberFormat = NumberFormat("#,###");
    final NumberFormat pointsFormat = NumberFormat("#,###.#");
    return Column(children: [
      Row(
        children: [
          Expanded(
              child: InfoCard(
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
                                : Text("${numberFormat.format(user.currentMyShareCredit / goal.goal * 100)}%",
                                    style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w800)),
                          ),
                          if (userRoundModel.myShareOnTrackPoints)
                            Align(
                              alignment: Alignment.topRight,
                              child: Image(
                                image: const AssetImage("assets/img/myshare-logo.png"),
                                fit: BoxFit.fitWidth,
                                height: 20.sp,
                              ),
                            )
                        ],
                      ),
                      Text("profile_myshare_status".i18n(), style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  onTap: () => ref.watch(profileDataProvider).userGoal == null
                      ? null
                      : showGeneralDialog(
                          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                          barrierColor: AppColors.primary,
                          transitionDuration: const Duration(milliseconds: 200),
                          context: context,
                          pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                            return MyShareStatusPage(
                                userGoalRound: UserGoalUserRoundModel(
                                    user: user,
                                    goal: ref.watch(profileDataProvider).userGoal!,
                                    round: userRoundModel.round));
                          }))),
          SizedBox(
            width: 12.sp,
          ),
          Expanded(
            child: InfoCard(
                height: 100.sp,
                padding: 10.sp,
                onTap: () {
                  ref.watch(userPointsDataProvider.notifier).getTransactionItems();
                  context.push("/userPoints").then((value) => ref.read(profileDataProvider.notifier).getUserInfo());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pointsFormat.format(userRoundModel.roundPoints),
                        style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w800)),
                    Text(
                      "profile_points".i18n(),
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: InfoCard(
                height: 100.sp,
                padding: 10.sp,
                onTap: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text("${Utils.creditFormatting(userRoundModel.samvirkPayments)} Ft",
                                style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w800),
                                textScaler: TextScaler.linear(
                                  Utils.textScaleFactor(context),
                                ))),
                        if (userRoundModel.samvirkOnTrackPoints)
                          Align(
                            alignment: Alignment.topRight,
                            child: Image(
                              image: const AssetImage("assets/img/Samvirk_logo.png"),
                              fit: BoxFit.fitWidth,
                              height: 20.sp,
                            ),
                          )
                      ],
                    ),
                    Text(
                      "profile_samvirk_payments".i18n(),
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
          ),
        ],
      )
    ]);
  }
}
