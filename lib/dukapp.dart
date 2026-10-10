import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/app_theme_mode.dart';
import 'package:work_hu/app/providers/router_provider.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/style/app_style.dart';
import 'package:work_hu/app/update/web_update_checker.dart';

import 'app/providers/auth_init_provider.dart';
import 'app/providers/locale_provider.dart';
import 'features/login/view/login_page.dart';

/// One key for the app's lifetime: a new key on every rebuild remounts everything under the MaterialApp.
final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Selected chips and segments use the primary container with its matching text color, in light and dark mode.
/// Without this a selected FilterChip / SegmentedButton got a pale color with unreadable text in dark mode.
ThemeData _withChipStyle(ThemeData theme) {
  final scheme = theme.colorScheme;
  return theme.copyWith(
    // The web keeps Material also in an iPhone browser; only the iOS app gets Cupertino widgets
    platform: kIsWeb ? TargetPlatform.android : null,
    // Cupertino switches, tab bar etc. in the iOS app take the app color instead of iOS blue/green
    cupertinoOverrideTheme: CupertinoThemeData(primaryColor: scheme.primary, applyThemeToAll: true),
    chipTheme: theme.chipTheme.copyWith(selectedColor: scheme.primaryContainer, showCheckmark: false),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? scheme.primaryContainer : null,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? scheme.onPrimaryContainer : scheme.onSurface,
        ),
      ),
    ),
  );
}

class DukApp extends ConsumerWidget {
  const DukApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.sizeOf(context).width;

    // Native apps use the full screen; the phone-sized frame is only for the web build.
    if (!kIsWeb) {
      return ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        ensureScreenSize: true,
        splitScreenMode: false,
        builder: (context, child) => buildMaterial(ref),
      );
    }

    return FlutterWebFrame(
      backgroundColor: AppColors.backgroundColor,
      builder: (context) {
        return ScreenUtilInit(
          designSize: const Size(360, 640),
          minTextAdapt: true,
          ensureScreenSize: true,
          enableScaleText: () => true,
          enableScaleWH: () => width > 500 ? false : true,
          splitScreenMode: false,
          builder: (context, child) {
            return Center(
              child: ClipRect(child: SizedBox(width: 500, child: buildMaterial(ref))),
            );
          },
        );
      },
      maximumSize: const Size(500, 1000),
    );
  }

  Widget buildMaterial(WidgetRef ref) {
    final authInit = ref.watch(authInitProvider);
    return authInit.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (err, stack) => LoginPage(),
      data: (_) {
        final theme = GlobalTheme();
        final router = ref.watch(routerProvider);
        final appThemeMode = ref.watch(themeProvider);
        final localeAsync = ref.watch(localeProvider);
        final Locale currentLocale = localeAsync.maybeWhen(
          data: (val) {
            return val;
          },
          orElse: () {
            return supportedLocales.first;
          }, // Fallback to your first supported locale
        );

        LocalJsonLocalization.delegate.directories = ['lib/I18n'];

        return MaterialApp.router(
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.trackpad},
          ),
          scaffoldMessengerKey: _scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: _withChipStyle(theme.globalTheme),
          darkTheme: _withChipStyle(theme.globalDarkTheme),
          themeMode: AppThemeMode.getThemeMode(appThemeMode),
          routerConfig: router,
          builder: (context, child) => WebUpdateChecker(child: child!),
          locale: currentLocale,
          supportedLocales: supportedLocales,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            LocalJsonLocalization.delegate,
            const LocaleNamesLocalizationsDelegate(),
          ],
        );
      },
    );
  }
}
