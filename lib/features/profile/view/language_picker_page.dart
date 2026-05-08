import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/home/data/state/home_state.dart';
import 'package:work_hu/features/home/providers/home_provider.dart';

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
          return ListTile(
            title: Text("${localeNames.nameOf(e.languageCode)}"),
            subtitle: Text(
              "${native?.substring(0, native.indexOf(" ("))}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              localeNotifier.setLocale(Locale(e.languageCode, e.countryCode));
            },
            trailing: currentLocale.value == e ? const Icon(Icons.check) : null,
          );
        }),
      ],
    );
  }

  @override
  AutoDisposeStateNotifierProvider<HomeDataNotifier, HomeState> get provider => homeDataProvider;

  @override
  BaseState get status => state.status;
}
