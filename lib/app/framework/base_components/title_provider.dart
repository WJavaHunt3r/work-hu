import 'package:flutter_riverpod/flutter_riverpod.dart';

final titleDataProvider = StateNotifierProvider.autoDispose<TitleDataNotifier, String>((ref) => TitleDataNotifier());

class TitleDataNotifier extends StateNotifier<String> {
  TitleDataNotifier() : super("");

  setTitle(String title) => state = title;
}
