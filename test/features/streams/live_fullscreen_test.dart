import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization/localization.dart';
import 'package:video_player/video_player.dart';
import 'package:work_hu/features/streams/view/live_player.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalJsonLocalization.delegate.directories = ['lib/I18n'];
    await LocalJsonLocalization.delegate.load(const Locale('hu', 'HU'));
  });

  testWidgets('fullscreen turns to landscape without the bars, and closing puts portrait and the bars back', (
    tester,
  ) async {
    final calls = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'SystemChrome.setPreferredOrientations') calls.add('orientations ${call.arguments}');
      if (call.method == 'SystemChrome.setEnabledSystemUIMode') calls.add('ui ${call.arguments}');
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));

    final video = ValueNotifier<VideoPlayerController?>(null); // still connecting
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (context, child) => MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => LiveFullscreenPage(video: video))),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    // the spinner never settles: pump through the page transition
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(calls, [
      'orientations [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]',
      'ui SystemUiMode.immersiveSticky',
    ]);
    expect(find.byType(CircularProgressIndicator), findsOneWidget); // waiting for the connection

    calls.clear();
    await tester.tap(find.byTooltip('Kilépés a teljes képernyőből'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('open'), findsOneWidget);
    expect(calls, [
      'orientations [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]',
      'ui SystemUiMode.edgeToEdge',
    ]);
  });
}
