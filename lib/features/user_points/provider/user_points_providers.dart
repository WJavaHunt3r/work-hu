import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_service.dart';
import 'package:work_hu/features/admin/data/repository/admin_repository.dart';
import 'package:work_hu/features/admin/providers/admin_provider.dart';
import 'package:work_hu/features/user_points/data/model/user_points_state.dart';

import '../../../work_hu_app.dart';

final userPointsDataProvider = StateNotifierProvider.autoDispose<UserPointsDataNotifier, UserPointsState>(
    (ref) => UserPointsDataNotifier(ref.read(adminRepoProvider), ref.read(routerProvider)));

class UserPointsDataNotifier extends StateNotifier<UserPointsState> {
  UserPointsDataNotifier(this.adminRepository, this.router) : super(const UserPointsState()) {
    getTransactionItems();
  }

  final AdminRepository adminRepository;
  final GoRouter router;

  Future<void> getTransactionItems() async {
    state = state.copyWith(modelState: ModelState.processing);

    try {
      var user = locator<UserService>().currentUser;
      var round = await adminRepository.getRound();
      await adminRepository
          .getTransactionItems(userId: user!.id, roundId: round.id)
          .then((value) => state = state.copyWith(transactionItems: value, modelState: ModelState.success));
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }
}
