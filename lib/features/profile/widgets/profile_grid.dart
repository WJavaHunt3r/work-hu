import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/info_widget.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_page.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';
import 'package:work_hu/features/user_points/provider/user_points_providers.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/utils.dart';

class ProfileGrid extends ConsumerWidget {
  const ProfileGrid(
      {required this.userRoundModel, super.key, required this.userStatus});

  final UserRoundModel userRoundModel;
  final UserStatusModel userStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel? user = userStatus.user;
    var isOnTrack = userStatus.status * 100 >= userRoundModel.round.myShareGoal;
    return Row(
      children: [
        Expanded(
            child: InfoCard(
                height: 110.sp,
                padding: 10.sp,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                              "${Utils.creditFormat.format(userStatus.status * 100)}%",
                              style: TextStyle(
                                  fontSize: 35.sp,
                                  fontWeight: FontWeight.w800)),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: InfoWidget(
                              infoText: "profile_myshare_status_info".i18n(),
                              shadowColor:
                                  ref.watch(themeProvider) == ThemeMode.dark
                                      ? AppColors.gray100
                                      : null,
                              iconData: Icons.info_outline,
                              iconColor:
                                  ref.watch(themeProvider) == ThemeMode.dark
                                      ? AppColors.primary100
                                      : AppColors.primary,
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
                    Text("profile_myshare_status".i18n(),
                        style: TextStyle(
                            fontSize: 10.sp, fontWeight: FontWeight.w600)),
                  ],
                ),
                onTap: () => showGeneralDialog(
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: AppColors.primary,
                    transitionDuration: const Duration(milliseconds: 200),
                    context: context,
                    pageBuilder: (BuildContext context, Animation animation,
                        Animation secondaryAnimation) {
                      return MyShareStatusPage(
                          userGoalRound: UserGoalUserRoundModel(
                              userStatus: userStatus,
                              round: userRoundModel.round));
                    }))),
        SizedBox(
          width: 4.sp,
        ),
        Expanded(
          child: InfoCard(
              height: 110.sp,
              padding: 10.sp,
              onTap: () {
                ref.read(userPointsDataProvider.notifier).setUserId(user.id);
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
                              Text(
                                  Utils.creditFormatting(
                                      user.points),
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w800)),
                            ],
                          )),
                      Align(
                          alignment: Alignment.topRight,
                          child: InfoWidget(
                            infoText: "profile_monthly_credits_info".i18n(),
                            iconData: Icons.info_outline,
                            shadowColor:
                                ref.watch(themeProvider) == ThemeMode.dark
                                    ? AppColors.gray100
                                    : null,
                            iconColor:
                                ref.watch(themeProvider) == ThemeMode.dark
                                    ? AppColors.primary100
                                    : AppColors.primary,
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "profile_points".i18n(),
                        style: TextStyle(
                            fontSize: 10.sp, fontWeight: FontWeight.w600),
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
