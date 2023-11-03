import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/user_points/data/model/user_points_state.dart';

import '../../../work_hu_app.dart';

final userPointsDataProvider = StateNotifierProvider.autoDispose<UserPointsDataNotifier, UserPointsState>((ref) =>
    UserPointsDataNotifier(
        ref.read(transactionItemsRepoProvider), ref.read(routerProvider), ref.read(userDataProvider)));

class UserPointsDataNotifier extends StateNotifier<UserPointsState> {
  UserPointsDataNotifier(this.transactionItemsRepository, this.router, this.currentUser)
      : super(const UserPointsState()) {
    getTransactionItems();
  }

  final TransactionItemsRepository transactionItemsRepository;
  final GoRouter router;
  final UserModel? currentUser;

  Future<void> getTransactionItems() async {
    state = state.copyWith(modelState: ModelState.processing);

    try {
      await transactionItemsRepository.getTransactionItems(userId: currentUser!.id).then((items) {
        items.sort((a, b) => a.transactionDate.compareTo(b.transactionDate));
        state = state.copyWith(transactionItems: items, modelState: ModelState.success);
      });
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }
}
