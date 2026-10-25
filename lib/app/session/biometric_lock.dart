import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:local_auth/local_auth.dart';
import 'package:work_hu/features/utils.dart';

/// Face ID / fingerprint (with the phone's own PIN as fallback) in front of a kept session: the app asks for it at
/// start and when it comes back after [BiometricLockNotifier.relockAfter] in the background. Switched on per device on
/// the Password and security page, off again at logout. Only the iOS and Android apps have it.
class BiometricLockState {
  const BiometricLockState({this.available = false, this.enabled = false, this.locked = false});

  /// The device can do it (app on iOS/Android, biometrics enrolled).
  final bool available;

  /// Switched on on this device.
  final bool enabled;

  /// The app is covered until the user unlocks it.
  final bool locked;

  BiometricLockState copyWith({bool? available, bool? enabled, bool? locked}) => BiometricLockState(
    available: available ?? this.available,
    enabled: enabled ?? this.enabled,
    locked: locked ?? this.locked,
  );
}

/// The device's biometric check; replaced in tests.
abstract class BiometricAuth {
  Future<bool> isAvailable();

  /// True when the user proved it's them; false when they cancelled or it failed.
  Future<bool> authenticate(String reason);
}

class LocalBiometricAuth implements BiometricAuth {
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    if (kIsWeb || !(Platform.isIOS || Platform.isAndroid)) return false;
    try {
      return await _auth.isDeviceSupported() && (await _auth.getAvailableBiometrics()).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, persistAcrossBackgrounding: true);
    } catch (_) {
      // LocalAuthException: cancelled, locked out, no biometrics any more, ...
      return false;
    }
  }
}

/// Where the on/off switch is kept; secure storage in the app, memory in tests.
abstract class BiometricSettingStore {
  Future<bool> read();

  Future<void> write(bool enabled);
}

class SecureBiometricSettingStore implements BiometricSettingStore {
  static const key = 'biometric_lock';

  @override
  Future<bool> read() async => await Utils.getData(key) == 'true';

  @override
  Future<void> write(bool enabled) async =>
      enabled ? Utils.saveData(key, 'true') : Utils.deleteData(key);
}

class BiometricLockNotifier extends StateNotifier<BiometricLockState> {
  BiometricLockNotifier(this._auth, this._store, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now,
      super(const BiometricLockState());

  /// Back from the background after this long: unlock again.
  static const relockAfter = Duration(minutes: 5);

  final BiometricAuth _auth;
  final BiometricSettingStore _store;
  final DateTime Function() _clock;
  DateTime? _backgroundSince;

  /// At start, once the session is restored: locks right away when it is on and someone is signed in.
  Future<void> init({required bool signedIn}) async {
    final available = await _auth.isAvailable();
    // Biometrics removed from the phone since: the switch no longer counts
    final enabled = available && await _store.read();
    state = BiometricLockState(available: available, enabled: enabled, locked: enabled && signedIn);
  }

  /// Switching it on needs one successful check, so nobody turns it on with a phone that isn't theirs to unlock.
  Future<bool> enable(String reason) async {
    if (!state.available) return false;
    if (!await _auth.authenticate(reason)) return false;
    await _store.write(true);
    state = state.copyWith(enabled: true, locked: false);
    return true;
  }

  Future<void> disable() async {
    await _store.write(false);
    state = state.copyWith(enabled: false, locked: false);
  }

  /// Signed out: off on this device, so the next person signing in here isn't held by it.
  Future<void> signedOut() async {
    _backgroundSince = null;
    if (!state.enabled && !state.locked) return;
    await disable();
  }

  Future<bool> unlock(String reason) async {
    if (!state.locked) return true;
    final ok = await _auth.authenticate(reason);
    if (ok) state = state.copyWith(locked: false);
    return ok;
  }

  void wentToBackground() {
    _backgroundSince ??= _clock();
  }

  void cameBack({required bool signedIn}) {
    final since = _backgroundSince;
    _backgroundSince = null;
    if (state.enabled && signedIn && since != null && shouldRelock(since, _clock())) {
      state = state.copyWith(locked: true);
    }
  }

  @visibleForTesting
  static bool shouldRelock(DateTime backgroundSince, DateTime now) => now.difference(backgroundSince) >= relockAfter;
}

final biometricLockProvider = StateNotifierProvider<BiometricLockNotifier, BiometricLockState>(
  (ref) => BiometricLockNotifier(LocalBiometricAuth(), SecureBiometricSettingStore()),
);
