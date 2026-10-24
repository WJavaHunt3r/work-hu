import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/users/widgets/user_create_dialog.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalJsonLocalization.delegate.directories = ['lib/I18n'];
    await LocalJsonLocalization.delegate.load(const Locale('hu', 'HU'));
  });

  Future<void> pumpDialog(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, child) => const MaterialApp(home: UserCreateDialog()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('an empty form shows what is missing instead of sending anything', (tester) async {
    await pumpDialog(tester);

    await tester.tap(find.text('Létrehozás'));
    await tester.pumpAndSettle();

    expect(find.text('Kötelező'), findsNWidgets(2)); // last name and first name
    expect(find.text('Adj meg érvényes e-mail-címet'), findsOneWidget);
  });

  testWidgets('a wrong e-mail address is caught', (tester) async {
    await pumpDialog(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'Kovács');
    await tester.enterText(find.byType(TextFormField).at(1), 'Éva');
    await tester.enterText(find.byType(TextFormField).at(2), 'not-an-address');
    await tester.tap(find.text('Létrehozás'));
    await tester.pumpAndSettle();

    expect(find.text('Kötelező'), findsNothing);
    expect(find.text('Adj meg érvényes e-mail-címet'), findsOneWidget);
  });
}
