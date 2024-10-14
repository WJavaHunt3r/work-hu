import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/user_fra_kare_week/provider/user_fra_kare_week_provider.dart';
import 'package:work_hu/features/user_fra_kare_week/view/user_fra_kare_week_layout.dart';

class UserFraKareWeekPage extends BasePage {
  UserFraKareWeekPage(
      {required this.weekNumber, super.key, super.title = "admin_user_fra_kare_week", super.isListView = true})
      : super(titleArgs: ["${weekNumber.toString()}."]);

  final num weekNumber;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    Future(() {
      ref.watch(userFraKareWeekDataProvider.notifier).setWeekNumber(weekNumber);
    });

    return UserFraKareWeekLayout(
      key: key,
    );
  }
}
