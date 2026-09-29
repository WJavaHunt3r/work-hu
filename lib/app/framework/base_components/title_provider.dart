import 'package:flutter_riverpod/legacy.dart';

final titleDataProvider = StateNotifierProvider.autoDispose<TitleDataNotifier, String>((ref) => TitleDataNotifier());

class TitleDataNotifier extends StateNotifier<String> {
  TitleDataNotifier() : super("");

  setTitle(String title) => state = title;
}
