import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/menu_options_list_tile.dart';
import 'package:work_hu/dukapp.dart';
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
                          : ProfileTabView(userRounds: userRounds, key: key),
                  ref.watch(profileDataProvider).userGoal == null
                      ? const SizedBox()
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.sp),
                          child: Row(
                            children: [
                              MonthlyCoin(
                                  month: "Aug",
                                  points: userRounds.isNotEmpty
                                      ? userRounds
                                          .firstWhere((e) => e.round.activeRound && e.round.roundNumber == 1,
                                              orElse: () => userRounds.first.copyWith(roundCoins: 0))
                                          .roundCoins
                                      : 0),
                              MonthlyCoin(
                                  month: "Szept",
                                  points: userRounds.isNotEmpty
                                      ? userRounds
                                          .firstWhere((e) => e.round.activeRound && e.round.roundNumber == 2,
                                              orElse: () => userRounds.first.copyWith(roundCoins: 0))
                                          .roundCoins
                                      : 0),
                              MonthlyCoin(
                                  month: "Okt",
                                  points: userRounds.isNotEmpty
                                      ? userRounds
                                          .firstWhere((e) => e.round.activeRound && e.round.roundNumber == 3,
                                              orElse: () => userRounds.first.copyWith(roundCoins: 0))
                                          .roundCoins
                                      : 0),
                              MonthlyCoin(
                                  month: "Nov",
                                  points: userRounds.isNotEmpty
                                      ? userRounds
                                          .firstWhere((e) => e.round.activeRound && e.round.roundNumber == 4,
                                              orElse: () => userRounds.first.copyWith(roundCoins: 0))
                                          .roundCoins
                                      : 0),
                              MonthlyCoin(
                                  month: "Dec",
                                  points: userRounds.isNotEmpty
                                      ? userRounds
                                          .firstWhere((e) => e.round.activeRound && e.round.roundNumber == 5,
                                              orElse: () => userRounds.first.copyWith(roundCoins: 0))
                                          .roundCoins
                                      : 0)
                            ],
                          ),
                        ),
                  ref.watch(profileDataProvider).fraKareWeeks.isEmpty ? const SizedBox() : FraKareStreak(),
                  Column(
                    children: [
                      MenuOptionsListTile(
                          title: "profile_details_title".i18n(),
                          onTap: () => showGeneralDialog(
                              barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                              barrierColor: AppColors.primary,
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
                              title: "profile_mentees_title".i18n(),
                              onTap: () => ref.read(routerProvider).push("/mentees"))
                          : const SizedBox(),
                      user.isMentor()
                          ? MenuOptionsListTile(
                              title: "profile_activities_title".i18n(),
                              onTap: () => ref.read(routerProvider).push("/activities"))
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
                                  content: Text("profile_logout_question".i18n())));
                        },
                        style: ButtonStyle(
                          side: WidgetStateBorderSide.resolveWith(
                            (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                          ),
                          backgroundColor: WidgetStateColor.resolveWith((states) => AppColors.backgroundColor),
                        ),
                        child: Text("profile_logout".i18n(),
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))),
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
