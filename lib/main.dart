import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/notifications/push_service.dart';
import 'package:work_hu/dukapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // Audio-only live streams: lock-screen controls and playback with the screen off (the web player is the embedded page)
  if (!kIsWeb) {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'org.bcc_ktk.dukapp.live',
      androidNotificationChannelName: 'Live',
      androidNotificationOngoing: true,
    );
  }
  await setupLocator();
  await PushService.instance.init();
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const ProviderScope(child: OverlaySupport.global(child: DukApp())));
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
