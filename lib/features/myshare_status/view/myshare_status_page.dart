import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/mentees/provider/mentees_provider.dart';
import 'package:work_hu/features/utils.dart';

/// A mentee's MyShare status. Opened from [MenteesPage], whose provider it shares.
class MyShareStatusPage extends BasePage {
  const MyShareStatusPage({
    super.key,
    super.title = "myshare_status_title",
    super.canRefresh = false,
    required this.userGoalRound,
  });

  final UserGoalUserRoundModel userGoalRound;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MyShareStatusPageState();
  }
}

class MyShareStatusPageState
    extends BasePageState<MyShareStatusPage, PagedState<UserGoalUserRoundModel, num>, MenteesDataNotifier> {
  @override
  Widget buildLayout() {
    var userStatusModel = widget.userGoalRound.userStatus;
    var username = widget.userGoalRound.userStatus.name;

    var currentRound = widget.userGoalRound.round;
    var userStatus = userStatusModel.status * 100;
    var isOnTrack = userStatus > currentRound.localMyShareGoal!;
    var toOnTrack = Utils.creditFormatting(
      (userStatusModel.goal) * (currentRound.localMyShareGoal!) / 100 - userStatusModel.transactions,
    );
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.sp),
          child: Text(
            username,
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w800),
          ),
        ),
        SfRadialGauge(
          enableLoadingAnimation: true,
          axes: [
            RadialAxis(
              minimum: 0,
              maximum: userStatusModel.goal.toDouble(),
              axisLineStyle: AxisLineStyle(thickness: 15.sp, cornerStyle: CornerStyle.bothCurve),
              showLabels: false,
              showTicks: false,
              pointers: [
                RangePointer(
                  value: userStatusModel.transactions.toDouble(),
                  cornerStyle: CornerStyle.bothCurve,
                  width: 15.sp,
                ),
                MarkerPointer(
                  color: AppColors.teamOrange,
                  value: (currentRound.localMyShareGoal ?? currentRound.myShareGoal) / 100 * (userStatusModel.goal),
                ),
              ],
              annotations: [
                GaugeAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${Utils.percentFormat.format(userStatus)} %",
                        style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        Utils.creditFormatting(userStatusModel.transactions),
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "myshare_status_goal".i18n([Utils.creditFormatting(userStatusModel.goal)]),
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                isOnTrack
                    ? "myshare_status_your_ontrack".i18n()
                    : "myshare_status_to_be_ontrack".i18n([toOnTrack.toString()]),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  StateNotifierProvider<MenteesDataNotifier, PagedState<UserGoalUserRoundModel, num>> get provider =>
      menteesDataProvider;

  @override
  BaseState get status => state.baseStatus;
}
