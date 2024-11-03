import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/utils.dart';

final themeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode?>((ref) => ThemeModeNotifier());

class ThemeModeNotifier extends StateNotifier<ThemeMode?> {
  ThemeModeNotifier() : super(null) {
    getTheme();
  }

  Future<void> setTheme(ThemeMode theme) async {
    state = theme;
    var themeString = theme == ThemeMode.dark ? 'dark' : 'light';
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: theme == ThemeMode.dark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: theme == ThemeMode.dark ? Colors.black : AppColors.backgroundColor));
    await Utils.saveData('theme', themeString);
  }

  Future<void> changeTheme() async {
    var theme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(theme);
  }

  Future<void> getTheme() async {
    var theme = await Utils.getData('theme');
    setTheme(theme == ''
        ? ThemeMode.system
        : theme == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light);
  }

  bool isDark() => state == ThemeMode.dark;

// void setMetaThemeColor(Color color) {
//   js.context.callMethod("setMetaThemeColor", [color.toHexString()]);
// }
}
