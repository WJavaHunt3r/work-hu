import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawerDataProvider = StateNotifierProvider.autoDispose<DrawerDataProvider, int>((ref) => DrawerDataProvider());

class DrawerDataProvider extends StateNotifier<int> {
  DrawerDataProvider() : super(1);

  void setCurrentDrawer(int current) {
    state = current;
  }
}
