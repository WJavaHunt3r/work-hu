import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Reloads with the newest deployed build. A plain reload is answered by Flutter's service worker from its cache and
/// brings the old build back, so the service workers and their caches are removed first.
Future<void> reloadPage() async {
  try {
    final registrations = (await web.window.navigator.serviceWorker.getRegistrations().toDart).toDart;
    for (final registration in registrations) {
      await registration.unregister().toDart;
    }
    final names = (await web.window.caches.keys().toDart).toDart;
    for (final name in names) {
      await web.window.caches.delete(name.toDart).toDart;
    }
  } catch (_) {
    // Reload anyway; at worst the cached build shows once more.
  }
  web.window.location.reload();
}
