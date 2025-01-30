import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/widgets/profile_grid.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/utils.dart';

class ProfileTabView extends ConsumerWidget {
  const ProfileTabView(
      {super.key,
      required this.userRound,
      required this.userStatus,
      this.titleText});

  final UserRoundModel userRound;
  final UserStatusModel userStatus;
  final String? titleText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentRound = ref.watch(roundDataProvider).currentRoundNumber;
    if (currentRound == 0) return const SizedBox();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12.sp),
                padding: EdgeInsets.symmetric(vertical: 6.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.sp),
                    color: AppColors.primary),
                child: Text(
                  titleText ?? "profile_week_number".i18n([currentRound.toString()]),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.white, fontSize: 22.sp),
                ),
              ),
            ),
          ],
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return ProfileGrid(
                userRoundModel: userRound, userStatus: userStatus);
          },
        )
      ],
    );
  }
}
