import 'package:flutter/material.dart';

enum AppThemeMode {
  system,
  light,
  dark;

  static ThemeMode getThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  static String getThemeModeLocale(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return "settings_appearance_light";
      case AppThemeMode.dark:
        return "settings_appearance_dark";
      case AppThemeMode.system:
        return "settings_appearance_system";
    }
  }
}
