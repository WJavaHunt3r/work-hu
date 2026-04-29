import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/user_camps/data/api/user_camp_api.dart';
import 'package:work_hu/features/user_camps/data/repository/user_camp_repository.dart';
import 'package:work_hu/features/user_camps/data/state/user_camp_state.dart';

final userCampApiProvider = Provider<UserCampApi>((ref) => UserCampApi());

final userCampRepoProvider = Provider<UserCampRepository>((ref) => UserCampRepository(ref.read(userCampApiProvider)));

final userCampDataProvider = StateNotifierProvider.autoDispose<UserCampDataNotifier, UserCampState>(
    (ref) => UserCampDataNotifier(ref.read(userCampRepoProvider), ref.read(userDataProvider).user));

class UserCampDataNotifier extends StateNotifier<UserCampState> {
  UserCampDataNotifier(this.userCampRepository, this.currentUser) : super(const UserCampState()) {
    getUserCamps();
  }

  final UserCampRepository userCampRepository;
  final UserModel? currentUser;

  Future<void> getUserCamps() async {
    state = state.copyWith(modelState: ModelState.loading);
    try {
      await userCampRepository.getUserCamps(seasonYear: DateTime.now().year, ).then((value) {
        // value.sort((a, b) => (a.getFullName()).compareTo(b.getFullName()));
        // state = state.copyWith(userCamp: value, filtered: value, modelState: ModelState.success);
      });
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> saveUser() async {
    state = state.copyWith(modelState: ModelState.loading);
    try {
      // var updatedUser = await userCampRepository.updateUser(currentUser!.id, state.selectedUser!);
      // state = state.copyWith(selectedUser: updatedUser, modelState: ModelState.success);
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  void updateCurrentUser(UserModel user) {
    // state = state.copyWith(selectedUser: user);
  }

  Future<void> downloadUserInfo() async {}
}
