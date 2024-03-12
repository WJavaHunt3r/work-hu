import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/mentees/provider/mentees_provider.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_page.dart';

class MenteesLayout extends ConsumerWidget {
  const MenteesLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var items = ref.watch(menteesDataProvider).menteesStatus;
    var state = ref.watch(menteesDataProvider).modelState;
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                  onRefresh: () async => ref.read(menteesDataProvider.notifier).getMentees(),
                  child: BaseListView(
                      cardBackgroundColor: Colors.transparent,
                      itemBuilder: (context, index) {
                        var current = items[index];
                        var style = TextStyle(color: current.isOnTrack() ? AppColors.white : AppColors.primary);
                        var isLast = items.length - 1 == index;
                        return ListCard(
                            isLast: isLast,
                            index: index,
                            child: ListTile(
                                onTap: () => showGeneralDialog(
                                    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                    barrierColor: AppColors.primary,
                                    transitionDuration: const Duration(milliseconds: 200),
                                    context: context,
                                    pageBuilder:
                                        (BuildContext context, Animation animation, Animation secondaryAnimation) {
                                      return MyShareStatusPage(
                                          userGoalRound: UserGoalUserRoundModel(
                                              user: current.user, goal: current.goal, round: current.round));
                                    }),
                                subtitle: Text(
                                  current.isOnTrack() ? "On Track" : current.getRemainingAmount(),
                                  style: style,
                                ),
                                title: Text(
                                  current.user.getFullName(),
                                  style: style,
                                ),
                                trailing: Text(
                                  current.getStatusString(),
                                  style: style.copyWith(fontSize: 15.sp),
                                ),
                                tileColor: current.isOnTrack() ? AppColors.primary : AppColors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: index == 0 && isLast
                                        ? BorderRadius.circular(8.sp)
                                        : index == 0
                                            ? BorderRadius.only(
                                                topLeft: Radius.circular(8.sp), topRight: Radius.circular(8.sp))
                                            : isLast
                                                ? BorderRadius.only(
                                                    bottomLeft: Radius.circular(8.sp),
                                                    bottomRight: Radius.circular(8.sp))
                                                : BorderRadius.zero)));
                      },
                      itemCount: items.length,
                      children: const [])),
            ),
          ],
        ),
        state == ModelState.processing
            ? const AlertDialog(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                content: Column(
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                ))
            : const SizedBox()
      ],
    );
  }
}
