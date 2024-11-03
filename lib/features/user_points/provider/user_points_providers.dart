import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activity_items/data/repository/activity_items_repository.dart';
import 'package:work_hu/features/activity_items/provider/activity_items_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/user_points/data/model/user_points_state.dart';

final userPointsDataProvider = StateNotifierProvider<UserPointsDataNotifier, UserPointsState>((ref) =>
    UserPointsDataNotifier(ref.read(transactionItemsRepoProvider), ref.read(userDataProvider),
        ref.read(roundDataProvider.notifier), ref.read(activityItemsRepoProvider)));

class UserPointsDataNotifier extends StateNotifier<UserPointsState> {
  UserPointsDataNotifier(
    this.transactionItemsRepository,
    this.currentUser,
    this.roundRepository,
    this.activityItemsRepository,
  ) : super(const UserPointsState());

  final TransactionItemsRepository transactionItemsRepository;
  final UserModel? currentUser;
  final RoundDataNotifier roundRepository;
  final ActivityItemsRepository activityItemsRepository;

  Future<void> getTransactionItems() async {
    state = state.copyWith(modelState: ModelState.processing);

    try {
      if (state.userId != null) {
        var rounds = roundRepository.state.rounds;
        var transactionItems = <TransactionItemModel>[];
        for (var r in rounds) {
          await transactionItemsRepository.getTransactionItems(userId: state.userId, roundId: r.id).then((items) async {
            transactionItems.addAll(items);
          });
        }
        transactionItems.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

        await activityItemsRepository.getActivityItems(registeredInApp: false, userId: state.userId).then(
            (acItems) async => state = state.copyWith(
                activityItems: acItems, transactionItems: transactionItems, modelState: ModelState.success));
      } else {
        state = state.copyWith(modelState: ModelState.error, message: "No User set");
      }
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setUserId(num userId) async {
    state = state.copyWith(userId: userId);
    await getTransactionItems();
  }
}
