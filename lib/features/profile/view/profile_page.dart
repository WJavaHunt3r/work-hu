import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/data/models/app_theme_mode.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/features/profile/view/profile_layout.dart';

class ProfilePage extends BasePage {
  const ProfilePage(
      {super.key, super.title = "profile", super.hasTitleWidget = true, super.isListView = true, super.centerTitle = true});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return const ProfileLayout();
  }

  // @override
  // Widget buildTitleWidget(WidgetRef ref) {
  //   var mode = ref.read(themeProvider);
  //   return IconButton(
  //       onPressed: () =>
  //           ref.read(themeProvider.notifier).setTheme(mode == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light),
  //       icon: Icon(mode == AppThemeMode.light ? Icons.dark_mode : Icons.light_mode));
  // }
}
