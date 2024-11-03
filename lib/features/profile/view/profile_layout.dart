import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/extensions/dark_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/menu_options_list_tile.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/widgets/fra_kare_streak.dart';
import 'package:work_hu/features/profile/widgets/monthly_coin.dart';
import 'package:work_hu/features/profile/widgets/profile_header.dart';
import 'package:work_hu/features/profile/widgets/profile_tab_view.dart';
import 'package:work_hu/features/users/widgets/user_details.dart';

class ProfileLayout extends ConsumerWidget {
  const ProfileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userDataProvider);
    var userRounds = ref.watch(profileDataProvider).userRounds;
    var roundPoints = ref.watch(profileDataProvider).roundPoints;
    return user == null
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  const ProfileHeader(),
                  ref.watch(profileDataProvider).userGoal == null || ref.watch(profileDataProvider).userRounds.isEmpty
                      ? const SizedBox()
                      : ref.watch(profileDataProvider).modelState == ModelState.processing
                          ? const Center(child: CircularProgressIndicator())
                          : ProfileTabView(
                              userRounds: userRounds, key: key, goal: ref.watch(profileDataProvider).userGoal),
                  ref.watch(profileDataProvider).childrenGoals.isEmpty
                      ? SizedBox()
                      : Column(children: [
                          for (var child in ref.watch(profileDataProvider).childrenGoals)
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.sp),
                              child: ProfileTabView(
                                  userRounds: ref
                                      .watch(profileDataProvider)
                                      .childrenUserRounds
                                      .where((ur) => ur.user.id == child.user!.id)
                                      .toList(),
                                  key: key,
                                  titleText: child.user!.getFullName(),
                                  goal: ref
                                      .watch(profileDataProvider)
                                      .childrenGoals
                                      .firstWhere((g) => g.user!.id == child.user!.id)),
                            )
                        ]),
                  ref.watch(profileDataProvider).userGoal == null
                      ? const SizedBox()
                      : MonthlyCoins(roundPoints: roundPoints),
                  ref.watch(profileDataProvider).fraKareWeeks.isEmpty ? const SizedBox() : FraKareStreak(),
                  Column(
                    children: [
                      MenuOptionsListTile(
                          title: "profile_bufe_title".i18n(), onTap: () => context.push("/profile/bufe")),
                      MenuOptionsListTile(
                          title: "profile_details_title".i18n(),
                          onTap: () => showGeneralDialog(
                              barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                              barrierColor: context.isDarkMode ? AppColors.primary100 : AppColors.primary,
                              transitionDuration: const Duration(milliseconds: 200),
                              context: context,
                              pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                                return UserDetails(
                                  user: user,
                                  enabled: false,
                                );
                              })),
                      user.isMentor()
                          ? MenuOptionsListTile(
                              title: "profile_mentees_title".i18n(), onTap: () => context.push("/mentees"))
                          : const SizedBox(),
                      user.isMentor()
                          ? MenuOptionsListTile(
                              title: "profile_activities_title".i18n(), onTap: () => context.push("/activities"))
                          : const SizedBox(),
                    ],
                  ),
                ],
              )),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(bottom: 8.sp),
                    child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => ConfirmAlertDialog(
                                  onConfirm: () {
                                    ref.read(profileDataProvider.notifier).logout();
                                    context.pop();
                                    context.replace("/");
                                  },
                                  title: "profile_logout_confirm_title".i18n(),
                                  content: Text(
                                    "profile_logout_question".i18n(),
                                    textAlign: TextAlign.center,
                                  )));
                        },
                        style: ButtonStyle(
                          // side: WidgetStateBorderSide.resolveWith(
                          //   (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                          // ),
                          backgroundColor: WidgetStateColor.resolveWith((states) =>
                              ref.watch(themeProvider) == ThemeMode.dark ? Colors.black : AppColors.backgroundColor),
                        ),
                        child: Text("profile_logout".i18n(), style: const TextStyle(fontWeight: FontWeight.w800))),
                  ))
                ],
              )
            ],
          );
  }

  isOnTrack(GoalModel? goal, UserRoundModel userRound) {
    return goal != null && userRound.user.currentMyShareCredit / goal.goal * 100 > userRound.round.myShareGoal;
  }
}
