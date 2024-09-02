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
                children: [
                  const ProfileHeader(),
                  ref.watch(profileDataProvider).userGoal == null
                      ? const SizedBox()
                      : ref.watch(profileDataProvider).modelState == ModelState.processing
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              height: 150.sp,
                              child: ProfileTabView(
                                userRounds: userRounds,
                              )),
                  ref.watch(profileDataProvider).userGoal == null
                      ? const SizedBox()
                      : Row(
                          children: [
                            buildMonthlyCoinWidget("Aug", userRounds.isNotEmpty ? userRounds[0].roundCoins : 0),
                            buildMonthlyCoinWidget("Szept", userRounds.length > 1 ? userRounds[1].roundCoins : 0),
                            buildMonthlyCoinWidget("Okt", userRounds.length > 2 ? userRounds[2].roundCoins : 0),
                            buildMonthlyCoinWidget("Nov", userRounds.length > 3 ? userRounds[3].roundCoins : 0),
                            buildMonthlyCoinWidget("Dec", userRounds.length > 4 ? userRounds[4].roundCoins : 0)
                          ],
                        ),
                  const Divider(),
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
                          : SizedBox(),
                      user.isMentor()
                          ? MenuOptionsListTile(
                              title: "profile_activities_title".i18n(),
                              onTap: () => ref.read(routerProvider).push("/activities"))
                          : SizedBox(),
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

  buildMonthlyCoinWidget(String month, num points) {
    return Expanded(
        child: SizedBox(
      height: 100.sp,
      child: Padding(
        padding: EdgeInsets.all(4.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              month,
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(
                child: Image(
                    image: AssetImage(
                        "assets/img/${points == 0 ? "PACE_Coin_Blank_Static.png" : "PACE_Coin_Buk_${points}_Spin_540px.gif"}"),
                    fit: BoxFit.fitWidth))
          ],
        ),
      ),
    ));
  }

  isOnTrack(GoalModel? goal, UserRoundModel userRound) {
    return goal != null && userRound.user.currentMyShareCredit / goal.goal * 100 > userRound.round.myShareGoal;
  }
}
