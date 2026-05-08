import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/providers/user_provider.dart' show userDataProvider;

final authInitProvider = FutureProvider<void>((ref) async {
  final userNotifier = ref.read(userDataProvider.notifier);
  await userNotifier.initUser();
});