import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/home/data/state/home_state.dart';
import 'package:work_hu/features/home/providers/home_provider.dart';

import '../../../app/widgets/base_list_item.dart';

class LanguagePickerPage extends BasePage {
  const LanguagePickerPage({super.key, super.title = "settings_language"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LanguagePickerPageState();
  }
}

class LanguagePickerPageState extends BasePageState<LanguagePickerPage, HomeState, HomeDataNotifier> {
  @override
  Widget buildLayout() {
    final localeNotifier = ref.read(localeProvider.notifier);

    final currentLocale = ref.watch(localeProvider);

    final localeNames = LocaleNames.of(context)!;

    return BaseListView(
      children: [
        ...supportedLocales.map((Locale e) {
          var native = LocaleNamesLocalizationsDelegate.nativeLocaleNames["${e.languageCode}_${e.countryCode}"];
          return BaseListTile(
            title: Text("${localeNames.nameOf(e.languageCode)}"),
            subtitle: Text(
              "${native?.substring(0, native.indexOf(" ("))}",
            ),
            onTap: () {
              localeNotifier.setLocale(Locale(e.languageCode, e.countryCode));
            },
            selected: currentLocale.value == e,
            trailing: currentLocale.value == e ? const Icon(Icons.check) : null,
            isLast: supportedLocales.indexOf(e) == supportedLocales.length - 1,
            index: supportedLocales.indexOf(e),
          );
        }),
      ],
    );
  }

  @override
  StateNotifierProvider<HomeDataNotifier, HomeState> get provider => homeDataProvider;

  @override
  BaseState get status => state.status;
}
