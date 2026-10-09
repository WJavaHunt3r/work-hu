import 'package:web/web.dart' as web;

/// On iOS, web push only works in the app installed to the home screen (iOS 16.4 or later), not in a Safari tab.
bool isIosBrowserTab() {
  final agent = web.window.navigator.userAgent;
  // iPadOS pretends to be a Mac; it is told apart by its touch screen
  final ios =
      agent.contains('iPhone') ||
      agent.contains('iPad') ||
      agent.contains('iPod') ||
      (agent.contains('Macintosh') && web.window.navigator.maxTouchPoints > 1);
  final installed = web.window.matchMedia('(display-mode: standalone)').matches;
  return ios && !installed;
}
