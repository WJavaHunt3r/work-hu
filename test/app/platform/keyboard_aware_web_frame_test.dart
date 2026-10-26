import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/platform/keyboard_aware_web_frame.dart';

void main() {
  testWidgets('the on-screen keyboard reaches the app inside the web frame', (tester) async {
    EdgeInsets? seen;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(390, 844), viewInsets: EdgeInsets.only(bottom: 300)),
        child: KeyboardAwareWebFrame(
          builder: (context) {
            seen = MediaQuery.viewInsetsOf(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(seen, const EdgeInsets.only(bottom: 300));
  });

  testWidgets('a chat input moves above the keyboard', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    const field = Key('field');

    Widget app(double keyboard) => MediaQuery(
      data: MediaQueryData(size: const Size(390, 844), viewInsets: EdgeInsets.only(bottom: keyboard)),
      child: KeyboardAwareWebFrame(
        builder: (context) => const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [Expanded(child: SizedBox()), TextField(key: field)],
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(app(0));
    final withoutKeyboard = tester.getBottomLeft(find.byKey(field)).dy;
    await tester.pumpWidget(app(300));
    final withKeyboard = tester.getBottomLeft(find.byKey(field)).dy;

    expect(withoutKeyboard - withKeyboard, closeTo(300, 1));
  });
}
