import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_hu/app/providers/router_provider.dart' show navigatorKey;
import 'package:work_hu/features/utils.dart';

/// Opens SumUp's hosted checkout (top-up, donation) and brings the user back to the app afterwards.
///
/// In the apps the checkout opens in the in-app browser: a Chrome Custom Tab on Android (Google Pay works there, not
/// in a plain WebView) and Safari's in-app view on iOS (Apple Pay works there). SumUp then redirects to
/// `web/payment-return.html`, which opens `dukapp://app/<success route>`; the app shows that route and
/// [returned] closes the in-app browser (Android's `PaymentReturnActivity` closes the Custom Tab). Redirects don't
/// open apps by themselves, which is why the web address alone used to leave people in the web app.
///
/// When that doesn't happen (the user closed the browser, the jump to the app was blocked), [pendingRoute] still
/// holds the success route: on Android it is opened as soon as the app is back in front; on iOS (Safari's in-app view
/// doesn't pause the app) the pages show a "check payment" button. The success pages ask SumUp for the real status,
/// so they show a failure (with "try again") when nothing was paid.
class CheckoutLauncher {
  CheckoutLauncher._();

  /// The page to show for the checkout that is open, or null.
  static final pendingRoute = ValueNotifier<String?>(null);

  static AppLifecycleListener? _lifecycle;

  /// SumUp's `redirect_url` for a payment whose result page is [successRoute] (e.g. `/balance/topUp/success/<ref>`).
  /// The web app is sent straight back to itself; the apps go through the return page.
  static String redirectUrl(String successRoute) =>
      kIsWeb ? Utils.appUrl(successRoute) : "${Utils.webAppUrl}/payment-return.html?to=$successRoute";

  /// Opens [hostedUrl]; [successRoute] is where the user comes back to (null: nothing to come back to).
  static Future<void> open(Uri hostedUrl, {String? successRoute}) async {
    pendingRoute.value = successRoute;
    // Android only: on iOS the app also "resumes" around the Apple Pay sheet while Safari's view is still open
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      _lifecycle ??= AppLifecycleListener(onResume: _onResume);
    }
    final mode = kIsWeb ? LaunchMode.platformDefault : LaunchMode.inAppBrowserView;
    if (!await launchUrl(hostedUrl, mode: mode, webOnlyWindowName: "_self")) {
      pendingRoute.value = null;
      throw Exception('Could not launch $hostedUrl');
    }
  }

  /// The result page is showing: forget the pending checkout and close the in-app browser if it is still open.
  static Future<void> returned() async {
    pendingRoute.value = null;
    if (kIsWeb) return;
    try {
      if (await supportsCloseForLaunchMode(LaunchMode.inAppBrowserView)) await closeInAppWebView();
    } catch (_) {
      // Nothing open, or the platform can't close it: the user closes it
    }
  }

  /// Opens the pending result page (the "check payment" button, or the app coming back to the front).
  static void showPending() {
    final route = pendingRoute.value;
    final context = navigatorKey.currentContext;
    if (route == null || context == null) return;
    GoRouter.of(context).go(route);
  }

  /// Android: the Custom Tab was closed or left. A moment later, so a return link that arrives at the same time
  /// (and reaches the result page, which calls [returned]) wins.
  static void _onResume() {
    if (pendingRoute.value == null) return;
    Timer(const Duration(milliseconds: 800), showPending);
  }
}
