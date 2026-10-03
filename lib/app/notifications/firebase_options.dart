import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Firebase web app config. Android and iOS read theirs from google-services.json / GoogleService-Info.plist.
///
/// The web app config is public (it ships in every page), so it is the default here and must match
/// web/firebase-messaging-sw.js. Only the VAPID key is still required at build time:
/// `flutter build web --dart-define=FIREBASE_VAPID_KEY=...`. Other values can be overridden the same way.
class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  static const String _apiKey = String.fromEnvironment(
    'FIREBASE_WEB_API_KEY',
    defaultValue: 'AIzaSyBrqSUmLzHJARi9PX-hisBq0NGmqintxYM',
  );
  static const String _appId = String.fromEnvironment(
    'FIREBASE_WEB_APP_ID',
    defaultValue: '1:470140408680:web:6235683a7eaf8cc8d3fcdd',
  );

  /// Web Push certificate key pair (Firebase console → Cloud Messaging → Web configuration).
  static const String vapidKey = String.fromEnvironment('FIREBASE_VAPID_KEY');

  static bool get webConfigured => _apiKey.isNotEmpty && _appId.isNotEmpty && vapidKey.isNotEmpty;

  static FirebaseOptions get web => const FirebaseOptions(
    apiKey: _apiKey,
    appId: _appId,
    messagingSenderId: '470140408680',
    projectId: 'dukapp-494509',
    authDomain: 'dukapp-494509.firebaseapp.com',
    storageBucket: 'dukapp-494509.firebasestorage.app',
  );
}
