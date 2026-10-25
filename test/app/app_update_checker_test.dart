import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:work_hu/app/update/app_update_checker.dart';

AppUpdateInfo info(UpdateAvailability availability, {int version = 36, bool immediate = true}) => AppUpdateInfo(
  updateAvailability: availability,
  immediateUpdateAllowed: immediate,
  immediateAllowedPreconditions: null,
  flexibleUpdateAllowed: true,
  flexibleAllowedPreconditions: null,
  availableVersionCode: version,
  installStatus: InstallStatus.unknown,
  packageName: 'com.ktk.dukapp',
  clientVersionStalenessDays: 1,
  updatePriority: 0,
);

void main() {
  late List<String> calls;
  late AppUpdateInfo answer;
  late bool userSaysYes;
  late DateTime now;

  AppUpdateChecker checker({bool failing = false}) => AppUpdateChecker(
    check: () async {
      calls.add('check');
      if (failing) throw Exception('ERROR_APP_NOT_OWNED: not installed from Google Play');
      return answer;
    },
    update: () async {
      calls.add('update');
      return AppUpdateResult.success;
    },
    ask: () async {
      calls.add('ask');
      return userSaysYes;
    },
    now: () => now,
  );

  setUp(() {
    calls = [];
    answer = info(UpdateAvailability.updateAvailable);
    userSaysYes = true;
    now = DateTime(2026, 10, 25, 12);
  });

  test('a newer version is offered and installed when the user agrees', () async {
    await checker().run();
    expect(calls, ['check', 'ask', 'update']);
  });

  test('"later" is kept for that version; a newer one is offered again', () async {
    userSaysYes = false;
    final c = checker();
    await c.run();
    now = now.add(AppUpdateChecker.minInterval);
    await c.run();
    expect(calls, ['check', 'ask', 'check']); // not asked again for version 36

    answer = info(UpdateAvailability.updateAvailable, version: 37);
    now = now.add(AppUpdateChecker.minInterval);
    await c.run();
    expect(calls, ['check', 'ask', 'check', 'check', 'ask']);
  });

  test('Play is asked at most every few hours', () async {
    answer = info(UpdateAvailability.updateNotAvailable);
    final c = checker();
    await c.run();
    now = now.add(const Duration(hours: 1));
    await c.run();
    expect(calls, ['check']);
    now = now.add(AppUpdateChecker.minInterval);
    await c.run();
    expect(calls, ['check', 'check']);
  });

  test('an interrupted update carries on without asking', () async {
    answer = info(UpdateAvailability.developerTriggeredUpdateInProgress);
    await checker().run();
    expect(calls, ['check', 'update']);
  });

  test('nothing is offered when Play does not allow it now or the app is not from Play', () async {
    answer = info(UpdateAvailability.updateAvailable, immediate: false);
    await checker().run();
    expect(calls, ['check']);

    calls.clear();
    await checker(failing: true).run(); // a local build: quietly nothing
    expect(calls, ['check']);
  });
}
