import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/goal/view/goals_layout.dart';

class GoalPage extends BasePage {
  const GoalPage({super.key, super.title = "admin_goals", super.hasSearchBar = true});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return const GoalsLayout();
  }

  @override
  searchBarChanged(WidgetRef ref, String text) {
    ref.watch(goalDataProvider.notifier).filterGoals(text);
  }

}
