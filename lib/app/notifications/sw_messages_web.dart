import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// The push service worker can't navigate the app's window itself, so on a tap it posts `{type: 'dukapp-open', route}`
/// to it (see web/firebase-messaging-sw.js).
void listenForOpenRoute(void Function(String route) onRoute) {
  web.window.navigator.serviceWorker.addEventListener(
    'message',
    ((web.Event event) {
      final data = (event as web.MessageEvent).data.dartify();
      if (data is Map && data['type'] == 'dukapp-open' && data['route'] is String) {
        onRoute(data['route'] as String);
      }
    }).toJS,
  );
}
