import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/dukapp.dart';
import 'package:work_hu/features/activity_items/data/repository/activity_items_repository.dart';
import 'package:work_hu/features/activity_items/provider/activity_items_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/user_points/data/model/user_points_state.dart';

final userPointsDataProvider = StateNotifierProvider.autoDispose<UserPointsDataNotifier, UserPointsState>((ref) =>
    UserPointsDataNotifier(ref.read(transactionItemsRepoProvider), ref.read(routerProvider), ref.read(userDataProvider),
        ref.read(roundRepoProvider), ref.read(activityItemsRepoProvider)));

class UserPointsDataNotifier extends StateNotifier<UserPointsState> {
  UserPointsDataNotifier(
    this.transactionItemsRepository,
    this.router,
    this.currentUser,
    this.roundRepository,
    this.activityItemsRepository,
  ) : super(const UserPointsState()) {
    getTransactionItems();
  }

  final TransactionItemsRepository transactionItemsRepository;
  final GoRouter router;
  final UserModel? currentUser;
  final RoundRepository roundRepository;
  final ActivityItemsRepository activityItemsRepository;

  Future<void> getTransactionItems() async {
    state = state.copyWith(modelState: ModelState.processing);

    try {
      await roundRepository.getRounds(DateTime.now().year).then((rounds) async {
        var transactionItems = <TransactionItemModel>[];
        for (var r in rounds) {
          await transactionItemsRepository.getTransactionItems(userId: currentUser!.id, roundId: r.id).then((items) {
            transactionItems.addAll(items);
          });
        }
        transactionItems.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

        await activityItemsRepository.getActivityItems(registeredInApp: false, userId: currentUser!.id).then(
            (acItems) => state = state.copyWith(
                activityItems: acItems, transactionItems: transactionItems, modelState: ModelState.success));
      });
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }
}
