import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/mentees/provider/mentees_provider.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_page.dart';

class MenteesPage extends BaseListPage {
  const MenteesPage({super.key, super.title = "mentees_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MenteesPageState();
  }
}

class MenteesPageState extends PagedListPageState<MenteesPage, UserGoalUserRoundModel, num, MenteesDataNotifier> {
  @override
  Widget buildListTile(UserGoalUserRoundModel item, int index) {
    var style = TextStyle(color: item.isOnTrack() ? AppColors.white : AppColors.primary);
    return BaseListTile(
      isLast: items.length - 1 == index,
      index: index,
      onTap: () => showGeneralDialog(
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: AppColors.primary,
        transitionDuration: const Duration(milliseconds: 200),
        context: context,
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return MyShareStatusPage(userGoalRound: item);
        },
      ),
      subtitle: Text(item.isOnTrack() ? "On Track" : item.getRemainingAmount(), style: style),
      title: Text(item.userStatus.name, style: style),
      trailing: Text(item.getStatusString(), style: style.copyWith(fontSize: 15.sp)),
      tileColor: item.isOnTrack() ? AppColors.primary : AppColors.white,
    );
  }

  @override
  get provider => menteesDataProvider;
}
