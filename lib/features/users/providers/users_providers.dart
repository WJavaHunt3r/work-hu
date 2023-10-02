import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/users/data/api/users_api.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/data/state/users_state.dart';

import '../../../work_hu_app.dart';

final usersApiProvider = Provider<UsersApi>((ref) => UsersApi());

final usersRepoProvider = Provider<UsersRepository>((ref) => UsersRepository(ref.read(usersApiProvider)));

final usersDataProvider = StateNotifierProvider<UsersDataNotifier, UsersState>(
    (ref) => UsersDataNotifier(ref.read(usersRepoProvider), ref.read(routerProvider)));

class UsersDataNotifier extends StateNotifier<UsersState> {
  UsersDataNotifier(this.usersRepository, this.router) : super(const UsersState()) {}

  final UsersRepository usersRepository;
  final GoRouter router;

  Future<void> getUsers(num transactionId) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {} on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }
}
