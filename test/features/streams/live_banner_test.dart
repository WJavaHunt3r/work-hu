import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/style/app_style.dart';
import 'package:work_hu/features/streams/data/model/live_stream_model.dart';
import 'package:work_hu/features/streams/providers/streams_provider.dart';
import 'package:work_hu/features/streams/view/live_page.dart';

double _luminance(Color c) => c.computeLuminance();

/// WCAG contrast ratio of two colours.
double contrast(Color a, Color b) {
  final l1 = math.max(_luminance(a), _luminance(b));
  final l2 = math.min(_luminance(a), _luminance(b));
  return (l1 + 0.05) / (l2 + 0.05);
}

void main() {
  const live = LiveStreamModel(uid: 'u', title: 'Sunday', language: 'hu', hlsUrl: 'h', iframeUrl: 'i');

  Future<void> pumpBanner(WidgetTester tester, {required bool dark}) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          liveStreamsProvider.overrideWith((ref) => Stream.value(const [live])),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          // The app's themes use screen-size units, so they are made after ScreenUtil is set up
          builder: (context, child) {
            final themes = GlobalTheme();
            return MaterialApp(
              theme: dark ? themes.globalDarkTheme : themes.globalTheme,
              home: const Scaffold(body: LiveBanner()),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final dark in [false, true]) {
    testWidgets('the live banner text is readable in the ${dark ? 'dark' : 'light'} theme', (tester) async {
      await pumpBanner(tester, dark: dark);

      final background = (tester.widget<Material>(
        find.descendant(of: find.byType(LiveBanner), matching: find.byType(Material)).first,
      )).color!;
      final textStyle = tester.widget<Text>(find.text('Magyar')).style!;

      expect(
        contrast(background, textStyle.color!),
        greaterThanOrEqualTo(4.5),
        reason: 'text ${textStyle.color} on $background',
      );
    });
  }

  test('the text colour follows the background: dark text on a light one and light text on a dark one', () {
    expect(contrast(const Color(0xFFFFDAD6), liveBannerForeground(const Color(0xFFFFDAD6))), greaterThan(7));
    expect(contrast(const Color(0xFF8C1D18), liveBannerForeground(const Color(0xFF8C1D18))), greaterThan(7));
  });
}
