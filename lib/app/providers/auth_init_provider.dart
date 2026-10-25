import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/providers/user_provider.dart' show userDataProvider;
import 'package:work_hu/app/session/biometric_lock.dart';

final authInitProvider = FutureProvider<void>((ref) async {
  final userNotifier = ref.read(userDataProvider.notifier);
  await userNotifier.initUser();
  // Before the app is first drawn, so a locked session never shows its content
  await ref.read(biometricLockProvider.notifier).init(signedIn: userNotifier.user != null);
});
