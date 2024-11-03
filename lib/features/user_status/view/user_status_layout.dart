import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_page.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/user_status/widgets/base_filter_chip.dart';
import 'package:work_hu/features/utils.dart';

class UserStatusLayout extends ConsumerWidget {
  const UserStatusLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userRounds = ref.watch(userStatusDataProvider).userRounds;
    var goals = ref.watch(userStatusDataProvider).goals;
    var currentRound = ref.watch(userStatusDataProvider).currentRound;
    var currentRoundGoal = currentRound == null ? 0 : currentRound.myShareGoal;
    return Stack(
      children: [
        Column(
          children: [
            ref.watch(userDataProvider)!.role == Role.ADMIN
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.sp),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 30.sp,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: createTeamFilterChips(context, ref),
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () => ref.watch(userStatusDataProvider.notifier).recalculate(),
                          child: const Icon(Icons.refresh_outlined),
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.sp),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 30.sp,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: createOrderByChips(context, ref),
                      ),
                    ),
                  ),
                  Text(
                      "${ref.watch(userStatusDataProvider).userRounds.where((e) => e.roundCoins >= 50).length} / ${userRounds.length.toString()}")
                ],
              ),
            ),
            Expanded(
              child: BaseListView(
                itemCount: userRounds.length,
                itemBuilder: (BuildContext context, int index) {
                  var userRound = userRounds[index];
                  var currentUser = userRound.user;
                  var currentUserGoal = goals.where((g) => g.user!.id == currentUser.id).isEmpty
                      ? null
                      : goals.firstWhere((g) => g.user!.id == currentUser.id);

                  var currentGoal = currentUserGoal?.goal ?? 0;
                  var userStatus = currentUser.currentMyShareCredit / currentGoal * 100;

                  var toOnTrack = currentGoal * currentRoundGoal / 100 - currentUser.currentMyShareCredit;

                  var style = TextStyle(
                      color: userStatus >= currentRoundGoal || userRound.roundCredits >= userRound.roundMyShareGoal
                          ? AppColors.white
                          : null);

                  var isLast = index == userRounds.length - 1;
                  return BaseListTile(
                    isLast: isLast,
                    index: index,
                    onTap: () => showGeneralDialog(
                        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                        barrierColor: AppColors.primary,
                        transitionDuration: const Duration(milliseconds: 200),
                        context: context,
                        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                          return MyShareStatusPage(
                              userGoalRound: UserGoalUserRoundModel(
                                  user: currentUser, goal: currentUserGoal!, round: currentRound!));
                        }),
                    minVerticalPadding: 0,
                    title: Text(
                      "${currentUser.getFullName()} (${userRound.roundCredits} / ${userRound.roundMyShareGoal})",
                      style: style,
                    ),
                    subtitle: userStatus >= currentRoundGoal || userRound.roundCredits >= userRound.roundMyShareGoal
                        ? const Text(
                            "On Track",
                            style: TextStyle(color: AppColors.white),
                          )
                        : Text("myshare_status_to_be_ontrack_short".i18n([Utils.creditFormatting(toOnTrack)])),
                    trailing: Text(
                      "${Utils.percentFormat.format(userStatus)}%",
                      style: style.copyWith(fontSize: 15.sp),
                    ),
                    tileColor: userRound.roundCredits >= userRound.roundMyShareGoal
                        ? AppColors.primary
                        : userStatus >= currentRoundGoal
                            ? Colors.grey
                            : null,
                  );
                },
                children: const [],
              ),
            ),
          ],
        ),
        ref.watch(userStatusDataProvider).modelState == ModelState.processing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox()
      ],
    );
  }

  List<Widget> createTeamFilterChips(BuildContext context, WidgetRef ref) {
    List<Widget> chips = [];
    for (var team in ref.watch(teamRoundDataProvider).teams.map((e) => e.team).toSet()) {
      bool isSelected = ref.watch(userStatusDataProvider).selectedTeamId == team.id;
      chips.add(BaseFilterChip(
          isSelected: isSelected,
          title: team.teamName,
          onSelected: (bool selected) =>
              ref.watch(userStatusDataProvider.notifier).setSelectedFilter(selected ? team : null)));
    }
    return chips;
  }

  createOrderByChips(BuildContext context, WidgetRef ref) {
    List<Widget> chips = [];

    chips.add(BaseFilterChip(
      isSelected: ref.watch(userStatusDataProvider).selectedOrderType == OrderByType.NAME,
      title: "myshare_status_name".i18n(),
      onSelected: (bool selected) => ref
          .watch(userStatusDataProvider.notifier)
          .setSelectedOrderType(selected ? OrderByType.NAME : OrderByType.NONE),
    ));
    chips.add(BaseFilterChip(
      isSelected: ref.watch(userStatusDataProvider).selectedOrderType == OrderByType.STATUS,
      title: "myshare_status_status".i18n(),
      onSelected: (bool selected) => ref
          .watch(userStatusDataProvider.notifier)
          .setSelectedOrderType(selected ? OrderByType.STATUS : OrderByType.NONE),
    ));
    return chips;
  }
}
