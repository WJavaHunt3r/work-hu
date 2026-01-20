import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/data/models/app_theme_mode.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/utils.dart';

// A StateNotifier that holds and manages the AppThemeMode
class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier() : super(AppThemeMode.light) {
    _loadTheme();
  }

  final themeKey = 'theme';

  // Load the saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    final savedTheme = Utils.getData(themeKey);

    if (savedTheme == 'light') {
      state = AppThemeMode.light;
    } else if (savedTheme == 'dark') {
      state = AppThemeMode.dark;
    } else {
      state = AppThemeMode.light;
    }
  }

  // Save the selected theme to SharedPreferences
  Future<void> setTheme(AppThemeMode mode) async {
    switch (mode) {
      case AppThemeMode.light:
        await Utils.saveData(themeKey, 'light');
        break;
      case AppThemeMode.dark:
        await Utils.saveData(themeKey, 'dark');
        break;
      case AppThemeMode.system:
        await Utils.saveData(themeKey, 'system');
        break;
    }
    state = mode; // Update the state
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: mode == AppThemeMode.dark ? Colors.black : AppColors.backgroundColor));
  }
}

// The provider to access the ThemeModeNotifier instance
final themeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
  return ThemeModeNotifier();
});
