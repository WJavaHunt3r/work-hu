
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/app_theme_mode.dart';
import 'package:work_hu/app/providers/router_provider.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/style/app_style.dart';

import 'app/providers/authInitProvider.dart';
import 'app/providers/localeProvider.dart';
import 'features/login/view/login_page.dart';

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
                    child: ClipRect(
                        child: SizedBox(
                  width: 500,
                  child: buildMaterial(ref),
                )));
              });
        },
        maximumSize: const Size(500, 1000));
  }

  buildMaterial(WidgetRef ref) {
    final authInit = ref.watch(authInitProvider);
    return authInit.when(
      loading: () => const Center(child: CircularProgressIndicator()),
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
          scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
          debugShowCheckedModeBanner: false,
          theme: theme.globalTheme,
          darkTheme: theme.globalDarkTheme,
          themeMode: AppThemeMode.getThemeMode(appThemeMode),
          routerConfig: router,
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
