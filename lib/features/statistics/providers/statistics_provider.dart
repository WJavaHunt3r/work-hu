import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/data/state/rounds_state.dart';
import 'package:work_hu/features/statistics/data/state/statistics_state.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/transactions/providers/transactions_provider.dart';

final statisticsDataProvider = StateNotifierProvider<StatisticsDataNotifier, StatisticsState>(
    (ref) => StatisticsDataNotifier(ref.read(transactionItemsRepoProvider)));

class StatisticsDataNotifier extends StateNotifier<StatisticsState> {
  StatisticsDataNotifier(
    this.transactionItemsRepository,
  ) : super(const StatisticsState()) {
    getTransactionItems(DateTime.now().year);
  }

  final TransactionItemsRepository transactionItemsRepository;

  Future<void> getTransactionItems([num? seasonYear]) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await transactionItemsRepository.getTransactionItems().then((data) async {

        state = state.copyWith();

      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

}
