import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const localeKey = 'appLocale';
const defaultLocale = Locale('en', 'US');
final supportedLocales = [
  const Locale('hu', 'HU'),
  const Locale('en', 'US'),
  // const Locale('no', 'NO'),
];
// Use AsyncNotifier to handle the initial async loading state
class LocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(localeKey);

    if (savedLanguageCode != null) {
      // Find the first supported locale that matches the saved language code
      final savedLocale = supportedLocales.firstWhere(
        (locale) => locale.languageCode == savedLanguageCode,
        orElse: () => defaultLocale, // Fallback if code is invalid
      );
      return savedLocale;
    }

    // If no saved locale, try the system locale
    final systemLocale = WidgetsBinding.instance.window.locale;
    final systemLanguageCode = systemLocale.languageCode;

    // Find the first supported locale that matches the system language
    final matchingLocale = supportedLocales.firstWhere(
      (locale) => locale.languageCode == systemLanguageCode,
      orElse: () => defaultLocale, // Fallback to default if not supported
    );

    return matchingLocale;
  }

  // Method to allow the user to change the locale
  Future<void> setLocale(Locale newLocale) async {
    // 1. Save the new locale to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(localeKey, newLocale.languageCode);

    // 2. Update the state in Riverpod
    state = AsyncValue.data(newLocale);
  }
}

// Define the provider
final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
