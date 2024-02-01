import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/users/data/api/users_api.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/data/state/users_state.dart';

import '../../../work_hu_app.dart';

final usersApiProvider = Provider<UsersApi>((ref) => UsersApi());

final usersRepoProvider = Provider<UsersRepository>((ref) => UsersRepository(ref.read(usersApiProvider)));

final usersDataProvider = StateNotifierProvider.autoDispose<UsersDataNotifier, UsersState>(
    (ref) => UsersDataNotifier(ref.read(usersRepoProvider), ref.read(routerProvider), ref.read(userDataProvider)));

class UsersDataNotifier extends StateNotifier<UsersState> {
  UsersDataNotifier(this.usersRepository, this.router, this.currentUser) : super(const UsersState()) {
    getUsers();
  }

  final UsersRepository usersRepository;
  final GoRouter router;
  final UserModel? currentUser;

  Future<void> getUsers([TeamModel? team]) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await usersRepository
          .getUsers(team)
          .then((value) {
            value.sort((a,b) => (a.getFullName()).compareTo(b.getFullName()));
            state = state.copyWith(users: value, modelState: ModelState.success);
      });
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }

  Future<void> resetUserPassword(num userId) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await usersRepository.resetPassword(userId, currentUser!.id);
      state = state.copyWith(modelState: ModelState.success);
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }

  Future<void> saveUser(num userId, UserModel user) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      var updatedUser = await usersRepository.updateUser(currentUser!.id, user);
      state = state.copyWith(currentUser: updatedUser, modelState: ModelState.success);
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }

  void setSelectedUser(UserModel user) {
    state = state.copyWith(currentUser: user);
  }

  void updateCurrentUser(user){
    state = state.copyWith(currentUser: user);
  }
}
