import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/app_theme_mode.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/home/data/state/home_state.dart';
import 'package:work_hu/features/home/providers/home_provider.dart';

class ThemePickerPage extends BasePage {
  const ThemePickerPage({super.key, super.title = "settings_theme"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ThemePickerPageState();
  }
}

class ThemePickerPageState extends BasePageState<ThemePickerPage, HomeState, HomeDataNotifier> {
  @override
  Widget buildLayout() {
    final themeNotifier = ref.read(themeProvider.notifier);
    final currentThemeMode = ref.watch(themeProvider);
    return BaseListView(
      children: [
        ...AppThemeMode.values.map((mode) {
          final String label = AppThemeMode.getThemeModeLocale(mode).i18n();
          return BaseListTile(
            title: Text(label),
            onTap: () {
              themeNotifier.setTheme(mode);
            },
            trailing: currentThemeMode == mode ? const Icon(Icons.check) : null,
            selected: currentThemeMode == mode,
            isLast: AppThemeMode.values.indexOf(mode) == AppThemeMode.values.length -1 ,
            index: AppThemeMode.values.indexOf(mode),
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
