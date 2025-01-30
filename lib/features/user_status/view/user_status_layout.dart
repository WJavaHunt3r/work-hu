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
    var userStatuses = ref.watch(userStatusDataProvider).userStatuses;
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
                          onPressed:
                              ref.watch(userStatusDataProvider).modelState !=
                                      ModelState.processing
                                  ? () => ref
                                      .watch(userStatusDataProvider.notifier)
                                      .recalculate()
                                  : null,
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
                      "${ref.watch(userStatusDataProvider).userStatuses.where((e) => e.status * 100 >= (ref.watch(userStatusDataProvider).currentRound?.myShareGoal ?? 0)).length} / ${userStatuses.length.toString()}")
                ],
              ),
            ),
            Expanded(
              child: BaseListView(
                itemCount: userStatuses.length,
                itemBuilder: (BuildContext context, int index) {
                  var currentUserStatus = userStatuses[index];
                  var currentUser = currentUserStatus.user;

                  var currentGoal = currentUserStatus.goal;
                  var userStatus = currentUserStatus.status * 100;

                  var toOnTrack = currentGoal * currentRoundGoal / 100 -
                      currentUserStatus.transactions;

                  var style = TextStyle(
                      color: userStatus >= currentRoundGoal
                          ? AppColors.white
                          : null);

                  var isLast = index == userStatuses.length - 1;
                  return BaseListTile(
                    isLast: isLast,
                    index: index,
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
                                  userStatus: currentUserStatus,
                                  round: currentRound!));
                        }),
                    minVerticalPadding: 0,
                    title: Text(
                      currentUser.getFullName(),
                      style: style,
                    ),
                    subtitle: currentUserStatus.onTrack
                        ? const Text(
                            "On Track",
                            style: TextStyle(color: AppColors.white),
                          )
                        : Text("myshare_status_to_be_ontrack_short"
                            .i18n([Utils.creditFormatting(toOnTrack)])),
                    trailing: Text(
                      "${Utils.percentFormat.format(userStatus)}%",
                      style: style.copyWith(fontSize: 15.sp),
                    ),
                    tileColor:
                        currentUserStatus.onTrack ? AppColors.primary : null,
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
    for (var team in ref.watch(teamRoundDataProvider).teams.toSet()) {
      bool isSelected =
          ref.watch(userStatusDataProvider).selectedTeamId == team.id;
      chips.add(BaseFilterChip(
          isSelected: isSelected,
          title: team.teamName,
          onSelected: (bool selected) => ref
              .watch(userStatusDataProvider.notifier)
              .setSelectedFilter(selected ? team : null)));
    }
    return chips;
  }

  createOrderByChips(BuildContext context, WidgetRef ref) {
    List<Widget> chips = [];

    chips.add(BaseFilterChip(
      isSelected: ref.watch(userStatusDataProvider).selectedOrderType ==
          OrderByType.NAME,
      title: "myshare_status_name".i18n(),
      onSelected: (bool selected) => ref
          .watch(userStatusDataProvider.notifier)
          .setSelectedOrderType(selected ? OrderByType.NAME : OrderByType.NONE),
    ));
    chips.add(BaseFilterChip(
      isSelected: ref.watch(userStatusDataProvider).selectedOrderType ==
          OrderByType.STATUS,
      title: "myshare_status_status".i18n(),
      onSelected: (bool selected) => ref
          .watch(userStatusDataProvider.notifier)
          .setSelectedOrderType(
              selected ? OrderByType.STATUS : OrderByType.NONE),
    ));
    return chips;
  }
}
