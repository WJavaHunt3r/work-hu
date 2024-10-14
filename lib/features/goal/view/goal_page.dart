import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/goal/view/goals_layout.dart';

class GoalPage extends BasePage {
  GoalPage({super.key, super.title = "admin_goals"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return GoalsLayout();
  }
}
