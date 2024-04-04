import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_page.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/user_status/widgets/base_filter_chip.dart';
import 'package:work_hu/features/utils.dart';

class UserStatusLayout extends ConsumerWidget {
  const UserStatusLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var users = ref.watch(userStatusDataProvider).users;
    var currentRoundNumber = ref.read(roundDataProvider).currentRoundNumber;
    var rounds = ref.read(roundDataProvider).rounds;
    var goals = ref.watch(goalDataProvider).goals;
    var currentRound =
        rounds.isEmpty ? null : rounds.firstWhere((element) => element.roundNumber == currentRoundNumber);
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
                  Text(users.length.toString())
                ],
              ),
            ),
            Expanded(
              child: BaseListView(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  var current = users[index];
                  var currentUserGoal = goals.where((g) => g.user!.id == current.id).isEmpty
                      ? null
                      : goals.firstWhere((g) => g.user!.id == current.id);
                  var currentGoal = currentUserGoal?.goal ?? 0;
                  var userStatus = current.currentMyShareCredit / currentGoal * 100;
                  var style = TextStyle(color: userStatus >= currentRoundGoal ? AppColors.white : AppColors.primary);
                  var toOnTrack = currentGoal * currentRoundGoal / 100 - current.currentMyShareCredit;
                  var isLast = index == users.length - 1;
                  return ListCard(
                      isLast: isLast,
                      index: index,
                      child: ListTile(
                          onTap: () => showGeneralDialog(
                              barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                              barrierColor: AppColors.primary,
                              transitionDuration: const Duration(milliseconds: 200),
                              context: context,
                              pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                                return MyShareStatusPage(
                                    userGoalRound: UserGoalUserRoundModel(
                                        user: current, goal: currentUserGoal!, round: currentRound!));
                              }),
                          minVerticalPadding: 0,
                          title: Text(
                            current.getFullName(),
                            style: style,
                          ),
                          subtitle: userStatus >= currentRoundGoal
                              ? const Text(
                                  "On Track",
                                  style: TextStyle(color: AppColors.white),
                                )
                              : Text("myshare_status_to_be_ontrack_short".i18n([Utils.creditFormatting(toOnTrack)])),
                          trailing: Text(
                            "${Utils.percentFormat.format(userStatus)}%",
                            style: style.copyWith(fontSize: 15.sp),
                          ),
                          tileColor: userStatus >= currentRoundGoal ? AppColors.primary : AppColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: index == 0 && isLast
                                  ? BorderRadius.circular(8.sp)
                                  : index == 0
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(8.sp), topRight: Radius.circular(8.sp))
                                      : isLast
                                          ? BorderRadius.only(
                                              bottomLeft: Radius.circular(8.sp), bottomRight: Radius.circular(8.sp))
                                          : BorderRadius.zero)));
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
          title: team.color.toString(),
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
