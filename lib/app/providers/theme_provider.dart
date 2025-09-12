import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/data/models/app_theme_mode.dart';

// A StateNotifier that holds and manages the AppThemeMode
class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier() : super(AppThemeMode.light) {
    _loadTheme();
  }

  final themeKey = 'themeMode';

  // Load the saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(themeKey);

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
    final prefs = await SharedPreferences.getInstance();
    switch (mode) {
      case AppThemeMode.light:
        await prefs.setString(themeKey, 'light');
        break;
      case AppThemeMode.dark:
        await prefs.setString(themeKey, 'dark');
        break;
      case AppThemeMode.system:
        await prefs.setString(themeKey, 'system');
        break;
    }
    state = mode; // Update the state
  }
}

// The provider to access the ThemeModeNotifier instance
final themeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
  return ThemeModeNotifier();
});
