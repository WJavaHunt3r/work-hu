import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/session/biometric_lock.dart';

class FakeAuth implements BiometricAuth {
  bool available = true;
  bool succeeds = true;
  int prompts = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(String reason) async {
    prompts++;
    return succeeds;
  }
}

class MemoryStore implements BiometricSettingStore {
  bool value = false;

  @override
  Future<bool> read() async => value;

  @override
  Future<void> write(bool enabled) async => value = enabled;
}

void main() {
  late FakeAuth auth;
  late MemoryStore store;
  late DateTime now;
  late BiometricLockNotifier lock;

  setUp(() {
    auth = FakeAuth();
    store = MemoryStore();
    now = DateTime(2026, 10, 25, 12);
    lock = BiometricLockNotifier(auth, store, clock: () => now);
  });

  test('a kept session starts locked when it is switched on', () async {
    store.value = true;
    await lock.init(signedIn: true);

    expect(lock.state.locked, isTrue);
    expect(await lock.unlock('reason'), isTrue);
    expect(lock.state.locked, isFalse);
  });

  test('nothing is locked without a session or with the switch off', () async {
    store.value = true;
    await lock.init(signedIn: false);
    expect(lock.state.locked, isFalse);

    store.value = false;
    await lock.init(signedIn: true);
    expect(lock.state.locked, isFalse);
  });

  test('biometrics removed from the phone: the switch no longer counts', () async {
    store.value = true;
    auth.available = false;
    await lock.init(signedIn: true);

    expect(lock.state.enabled, isFalse);
    expect(lock.state.locked, isFalse);
  });

  test('a failed or cancelled check keeps it locked', () async {
    store.value = true;
    await lock.init(signedIn: true);
    auth.succeeds = false;

    expect(await lock.unlock('reason'), isFalse);
    expect(lock.state.locked, isTrue);
  });

  test('switching on needs one successful check', () async {
    await lock.init(signedIn: true);
    auth.succeeds = false;
    expect(await lock.enable('reason'), isFalse);
    expect(store.value, isFalse);

    auth.succeeds = true;
    expect(await lock.enable('reason'), isTrue);
    expect(store.value, isTrue);
    expect(lock.state.locked, isFalse);
  });

  test('locks again only after 5 minutes in the background', () async {
    store.value = true;
    await lock.init(signedIn: true);
    await lock.unlock('reason');

    lock.wentToBackground();
    now = now.add(const Duration(minutes: 4, seconds: 59));
    lock.cameBack(signedIn: true);
    expect(lock.state.locked, isFalse);

    lock.wentToBackground();
    now = now.add(BiometricLockNotifier.relockAfter);
    lock.cameBack(signedIn: true);
    expect(lock.state.locked, isTrue);
  });

  test('signing out switches it off on this device', () async {
    store.value = true;
    await lock.init(signedIn: true);

    await lock.signedOut();

    expect(store.value, isFalse);
    expect(lock.state.enabled, isFalse);
    expect(lock.state.locked, isFalse);
  });
}
