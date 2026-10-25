import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/app/providers/router_provider.dart' show navigatorKey;

/// Tells Android users about a newer version in Google Play and installs it from inside the app (Play's in-app
/// updates: [InAppUpdate.performImmediateUpdate] shows Play's update screen, then the app restarts on the new version).
///
/// Runs at startup and when the app comes back to the front, at most every [minInterval]. Only an app installed from
/// Google Play gets an answer (also on test tracks); a local build or another store makes the check fail, which is
/// ignored. "Later" is remembered for that version until the app is started again. iOS has no such API (TestFlight and
/// the App Store tell people themselves), nor does the web.
class AppUpdateChecker {
  AppUpdateChecker({
    Future<AppUpdateInfo> Function()? check,
    Future<AppUpdateResult> Function()? update,
    Future<bool> Function()? ask,
    DateTime Function()? now,
  }) : _check = check ?? InAppUpdate.checkForUpdate,
       _update = update ?? InAppUpdate.performImmediateUpdate,
       _ask = ask ?? _askUser,
       _now = now ?? DateTime.now;

  static final instance = AppUpdateChecker();

  static const minInterval = Duration(hours: 6);

  /// Whether this platform can update itself through Google Play.
  static bool get supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  final Future<AppUpdateInfo> Function() _check;
  final Future<AppUpdateResult> Function() _update;
  final Future<bool> Function() _ask;
  final DateTime Function() _now;

  DateTime? _lastCheck;
  bool _running = false;
  int? _declinedVersion;

  /// Asks Play whether there is a newer version and, if so, the user whether to install it now.
  Future<void> run() async {
    if (_running) return;
    final now = _now();
    if (_lastCheck != null && now.difference(_lastCheck!) < minInterval) return;
    _running = true;
    _lastCheck = now;
    try {
      final info = await _check();
      if (info.updateAvailability == UpdateAvailability.developerTriggeredUpdateInProgress) {
        // An update started earlier was interrupted (the app was closed): carry on with it
        await _update();
      } else if (info.updateAvailability == UpdateAvailability.updateAvailable &&
          info.immediateUpdateAllowed &&
          info.availableVersionCode != _declinedVersion) {
        if (await _ask()) {
          await _update();
        } else {
          _declinedVersion = info.availableVersionCode;
        }
      }
    } catch (_) {
      // Not installed from Google Play, no Play services, offline: nothing to offer
    } finally {
      _running = false;
    }
  }

  static Future<bool> _askUser() async {
    final context = navigatorKey.currentContext;
    if (context == null) return false;
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AdaptiveAlertDialog(
        title: Text("app_update_title".i18n()),
        content: Text("app_update_text".i18n()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("app_update_later".i18n())),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text("app_update_now".i18n())),
        ],
      ),
    );
    return yes ?? false;
  }
}
