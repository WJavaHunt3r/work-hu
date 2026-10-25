import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/providers/router_provider.dart' show navigatorKey;
import 'package:work_hu/features/payments/checkout_launcher.dart';

/// The app's router as far as payments go: the balance, the top-up result and the donation result.
GoRouter testRouter() => GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/balance',
  routes: [
    GoRoute(path: '/balance', builder: (context, state) => const Text('balance')),
    GoRoute(
      path: '/balance/topUp/success/:ref',
      builder: (context, state) => Text('top-up result ${state.pathParameters['ref']}'),
    ),
    GoRoute(
      path: '/donate/:id/success/:ref',
      builder: (context, state) => Text('donation ${state.pathParameters['id']} result ${state.pathParameters['ref']}'),
    ),
  ],
);

/// What the platform does when the app is opened with [link].
Future<void> openLink(WidgetTester tester, String link) async {
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    SystemChannels.navigation.name,
    SystemChannels.navigation.codec.encodeMethodCall(
      MethodCall('pushRouteInformation', {'location': link, 'state': null}),
    ),
    (_) {},
  );
  await tester.pumpAndSettle();
}

void main() {
  test('apps come back through the return page, the web app straight to itself', () {
    // the tests run outside the web
    expect(
      CheckoutLauncher.redirectUrl('/balance/topUp/success/{checkout_reference}'),
      'https://dukapp.bcc-ktk.org/payment-return.html?to=/balance/topUp/success/{checkout_reference}',
    );
  });

  testWidgets('the return page\'s dukapp://app link opens the top-up result', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: testRouter()));
    expect(find.text('balance'), findsOneWidget);

    await openLink(tester, 'dukapp://app/balance/topUp/success/abc-123');
    expect(find.text('top-up result abc-123'), findsOneWidget);
  });

  testWidgets('a donation reference with [ ] arrives decoded', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: testRouter()));

    await openLink(tester, 'dukapp://app/donate/7/success/donation_7_%5B1a2b3%5D');
    expect(find.text('donation 7 result donation_7_[1a2b3]'), findsOneWidget);
  });

  testWidgets('the pending result page opens on "check payment" and is forgotten on return', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: testRouter()));

    CheckoutLauncher.pendingRoute.value = '/balance/topUp/success/xyz';
    CheckoutLauncher.showPending();
    await tester.pumpAndSettle();
    expect(find.text('top-up result xyz'), findsOneWidget);

    await CheckoutLauncher.returned();
    expect(CheckoutLauncher.pendingRoute.value, isNull);
    CheckoutLauncher.showPending(); // nothing pending: nothing happens
    await tester.pumpAndSettle();
    expect(find.text('top-up result xyz'), findsOneWidget);
  });
}
