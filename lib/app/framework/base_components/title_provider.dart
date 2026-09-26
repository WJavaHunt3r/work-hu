import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final titleDataProvider = StateNotifierProvider.autoDispose<TitleDataNotifier, String>((ref) => TitleDataNotifier());

class TitleDataNotifier extends StateNotifier<String> {
  TitleDataNotifier() : super("");

  setTitle(String title) => state = title;
}
