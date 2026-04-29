import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/widgets/scale_scroll_view.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/utils.dart';

class UserStatusWidget extends ConsumerWidget {
  const UserStatusWidget({super.key, required this.userRound, required this.userStatus, this.titleText});

  final UserRoundModel userRound;
  final UserStatusModel userStatus;
  final String? titleText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8.sp), bottomRight: Radius.circular(8.sp)),
                      color: Theme.of(context).colorScheme.primary),
                  child: Text(
                    userStatus.user.getFullName(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                  )),
              Padding(
                padding: EdgeInsets.all(12.sp),
                child: userStatus.onTrack
                    ? Text(
                        "On Track",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                      )
                    : Text(
                        "Not On Track",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.error),
                      ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 22.sp),
            child: FreeScrollList(
              elements: [
                Column(
                  children: [
                    Text("${Utils.percentFormat.format(userStatus.status * 100)}%",
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      "Státuszod",
                    )
                  ],
                ),
                Column(
                  children: [
                    Text("${Utils.creditFormatting(userRound.round.localMyShareGoal!)}%",
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      "Havi cél",
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(Utils.creditFormatting(userRound.roundCredits), style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      "Havi kreditek",
                    )
                  ],
                ),
                Column(
                  children: [
                    Text("${Utils.creditFormatting(Math.max(userRound.roundMyShareGoal, 0))}",
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      "Még gyűjtendő",
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
