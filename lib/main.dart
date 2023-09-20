import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/style/app_style.dart';
import 'package:work_hu/work_hu_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SecurityContext(withTrustedRoots: false);
  await ScreenUtil.ensureScreenSize();
  await setupLocator();
  runApp(ProviderScope(child: OverlaySupport.global(child: WorkHuApp())));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}
