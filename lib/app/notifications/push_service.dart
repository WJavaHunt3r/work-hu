import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:work_hu/app/notifications/deep_link.dart';
import 'package:work_hu/app/notifications/firebase_options.dart';
import 'package:work_hu/app/notifications/sw_messages_stub.dart'
    if (dart.library.js_interop) 'package:work_hu/app/notifications/sw_messages_web.dart';
import 'package:work_hu/app/notifications/pwa_info_stub.dart'
    if (dart.library.js_interop) 'package:work_hu/app/notifications/pwa_info_web.dart';
import 'package:work_hu/app/providers/router_provider.dart';
import 'package:work_hu/features/notifications/data/api/notification_api.dart';
import 'package:work_hu/features/utils.dart';

/// Messages that arrive while the app is in the background or closed are shown by the OS (Android/iOS) or by
/// web/firebase-messaging-sw.js. This only has to exist, it runs in its own isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) await Firebase.initializeApp();
}

/// Why push does or doesn't work on this device, for the notification settings.
enum PushStatus {
  /// Permission given and the device is registered with the backend.
  enabled,

  /// Never asked, or asked and left open: the user can turn it on.
  notEnabled,

  /// The user (or the system) blocked notifications for the app.
  denied,

  /// This browser or device can't do push (or it isn't set up).
  unsupported,

  /// iPhone/iPad browser tab: push only works in the app added to the home screen.
  installNeeded,

  /// Permission is given but the device could not be registered with the backend.
  registrationFailed,
}

/// Firebase Cloud Messaging for web, Android and iOS: permission, device token registration with the backend and
/// opening the right screen when a notification is tapped.
class PushService {
  PushService._();

  static final PushService instance = PushService._();

  static const _lastTokenKey = 'fcm_token';
  static const _promptedKey = 'push_prompted';

  final NotificationApi _api = NotificationApi();
  bool _initialized = false;
  bool _available = false;
  String? _registeredToken;

  /// What went wrong the last time starting push or registering the device failed; shown to help find the cause.
  String? lastError;

  /// False when Firebase could not start (e.g. web without a configured Firebase app); everything then no-ops.
  bool get available => _available;

  String get _platform {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
  }

  /// Call once from `main()`, before `runApp`.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    try {
      if (kIsWeb) {
        // Without a web app registered in Firebase there is nothing to connect to; push stays off on web.
        if (!DefaultFirebaseOptions.webConfigured) {
          lastError = 'Firebase web config missing in this build';
          return;
        }
        await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
        if (!await FirebaseMessaging.instance.isSupported()) {
          lastError = 'This browser does not support web push';
          return;
        }
      } else {
        await Firebase.initializeApp();
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      }
      _available = true;

      final messaging = FirebaseMessaging.instance;
      // iOS does not show notifications of a foreground app by itself; the in-app banner below does.
      await messaging.setForegroundNotificationPresentationOptions(alert: false, badge: true, sound: false);

      // A tap on a notification while the web app is open arrives as a message from the push service worker
      if (kIsWeb) listenForOpenRoute(openLocation);

      FirebaseMessaging.onMessage.listen(_showInAppBanner);
      FirebaseMessaging.onMessageOpenedApp.listen((m) => _open(m.data));
      messaging.onTokenRefresh.listen((token) => _register(token));

      // App was closed and opened by tapping a notification.
      final initial = await messaging.getInitialMessage();
      if (initial != null) _open(initial.data);
    } catch (e) {
      _available = false;
      lastError = e.toString();
      debugPrint('Push notifications unavailable: $e');
    }
  }

  /// Where push stands on this device, to explain it in the notification settings.
  Future<PushStatus> status() async {
    if (kIsWeb && isIosBrowserTab()) return PushStatus.installNeeded;
    if (!_available) return PushStatus.unsupported;
    final settings = await authorizationStatus;
    if (settings == AuthorizationStatus.denied) return PushStatus.denied;
    if (settings == AuthorizationStatus.authorized || settings == AuthorizationStatus.provisional) {
      return _registeredToken != null ? PushStatus.enabled : PushStatus.registrationFailed;
    }
    return PushStatus.notEnabled;
  }

  Future<bool> get isAuthorized async {
    if (!_available) return false;
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<AuthorizationStatus> get authorizationStatus async {
    if (!_available) return AuthorizationStatus.notDetermined;
    return (await FirebaseMessaging.instance.getNotificationSettings()).authorizationStatus;
  }

  /// Asks the OS/browser for permission (a no-op if already decided) and registers this device when granted.
  Future<bool> requestPermissionAndRegister() async {
    if (!_available) return false;
    final settings = await FirebaseMessaging.instance.requestPermission();
    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    if (granted) await registerCurrentDevice();
    return granted;
  }

  /// Called after sign-in. Registers silently when permission exists, and (in the apps) asks once when it was never asked.
  Future<void> onSignedIn() async {
    if (!_available) return;
    try {
      if (await isAuthorized) {
        await registerCurrentDevice();
        return;
      }
      // Browsers (iOS Safari above all) ignore permission requests that don't come from a tap, so on the web the
      // user turns notifications on with the button in the notification settings. The apps can ask right away.
      if (kIsWeb) return;
      final status = await authorizationStatus;
      final prompted = await Utils.getData(_promptedKey) == 'true';
      if (status == AuthorizationStatus.notDetermined && !prompted) {
        await Utils.saveData(_promptedKey, 'true');
        await requestPermissionAndRegister();
      }
    } catch (e) {
      debugPrint('Push registration failed: $e');
    }
  }

  Future<void> registerCurrentDevice() async {
    if (!_available) return;
    try {
      final token = await FirebaseMessaging.instance.getToken(
        vapidKey: kIsWeb ? DefaultFirebaseOptions.vapidKey : null,
      );
      if (token != null) {
        await _register(token);
      } else {
        lastError = 'Firebase gave no push token';
      }
    } catch (e) {
      lastError = e.toString();
      debugPrint('Could not get the push token: $e');
    }
  }

  Future<void> _register(String token) async {
    if (token == _registeredToken) return;
    try {
      await _api.registerDevice(token: token, platform: _platform);
      _registeredToken = token;
      lastError = null;
      await Utils.saveData(_lastTokenKey, token);
    } catch (e) {
      lastError = e.toString();
      // Not signed in yet or offline; onSignedIn registers again next time.
      debugPrint('Could not register the device token: $e');
    }
  }

  /// Called on logout, while the access token is still known, so this device stops receiving the user's pushes.
  Future<void> onSigningOut({String? bearer}) async {
    final token = _registeredToken ?? await Utils.getData(_lastTokenKey);
    _registeredToken = null;
    await Utils.deleteData(_lastTokenKey);
    if (token.isEmpty) return;
    try {
      await _api.unregisterDevice(token: token, bearer: bearer).timeout(const Duration(seconds: 4));
    } catch (_) {
      // Best effort; the backend also drops tokens FCM reports as invalid.
    }
    if (_available) {
      try {
        // A new token is issued for the next user of this device.
        await FirebaseMessaging.instance.deleteToken();
      } catch (_) {}
    }
  }

  void _showInAppBanner(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    showOverlayNotification((context) {
      final theme = Theme.of(context);
      return SafeArea(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            leading: Icon(Icons.notifications, color: theme.colorScheme.primary),
            title: Text(notification.title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: notification.body == null ? null : Text(notification.body!, maxLines: 2),
            onTap: () {
              OverlaySupportEntry.of(context)?.dismiss();
              _open(message.data);
            },
          ),
        ),
      );
    }, duration: const Duration(seconds: 5));
  }

  void _open(Map<String, dynamic> data) {
    final location = DeepLink.fromPushData(data);
    if (location != null) openLocation(location);
  }

  /// Navigates to [location]; the router sends signed-out users to login and brings them here afterwards.
  void openLocation(String location) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      // The router is not built yet (cold start from a notification); the redirect picks this up.
      DeepLink.remember(location);
      return;
    }
    GoRouter.of(context).go(location);
  }
}
