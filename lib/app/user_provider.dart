import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/utils.dart';

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserModel?>((ref) => UserDataNotifier());

class UserDataNotifier extends StateNotifier<UserModel?> {
  UserDataNotifier() : super(null);

  Future<void> setUser(UserModel? user) async {
    state = user;
    if (user == null) {
      await Utils.saveData('user', '');
      await Utils.saveData('password', '');
    }
  }
}
