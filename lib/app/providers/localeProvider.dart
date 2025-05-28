import 'dart:ui';
import 'package:universal_io/io.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/utils.dart';

final localeProvider = StateNotifierProvider<LocaleModeNotifier, Locale?>((ref) => LocaleModeNotifier());

class LocaleModeNotifier extends StateNotifier<Locale?> {
  LocaleModeNotifier() : super(Platform.localeName == 'hu_HU'
      ? Locale("hu")
      : Locale("en")) {
    getLocale();
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    var localeString = locale == Locale("hu" , "HU") ? 'hu' : 'en';
    await Utils.saveData('locale', localeString);
  }

  Future<void> changeLocale() async {
    var theme = state == Locale("hu", "HU") ? Locale("en", "US") : Locale("hu", "HU");
    await setLocale(theme);
  }

  Future<void> getLocale() async {
    var locale = await Utils.getData('locale');
    setLocale(locale == ''
        ? Platform.localeName == 'hu-HU'
            ? Locale("hu", "HU")
            : Locale("en", "US")
        : Locale(locale));
  }

// void setMetaLocaleColor(Color color) {
//   js.context.callMethod("setMetaLocaleColor", [color.toHexString()]);
// }
}
