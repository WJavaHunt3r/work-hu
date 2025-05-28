import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/router_provider.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/style/app_style.dart';

import 'app/providers/localeProvider.dart';

class DukApp extends ConsumerWidget {
  const DukApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.sizeOf(context).width;
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
                LocalJsonLocalization.delegate.directories = ['lib/I18n'];
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
    final theme = GlobalTheme();
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
      debugShowCheckedModeBanner: false,
      title: 'DukApp',
      theme: theme.globalTheme,
      darkTheme: theme.globalDarkTheme,
      themeMode: ref.watch(themeProvider),
      routerConfig: router,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hu', 'HU'),
      ],
      locale: const Locale('hu', 'HU'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
    );
  }
}
