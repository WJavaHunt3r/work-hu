import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_layout.dart';

class MyShareStatusPage extends BasePage {
  const MyShareStatusPage({super.key, super.title = "MyShare Status", required this.userGoalRound});

  final UserGoalUserRoundModel userGoalRound;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return MyShareStatusLayout(userGoalRound: userGoalRound);
  }
}
