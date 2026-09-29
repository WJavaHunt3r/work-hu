import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/features/statistics/data/state/statistics_state.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';

final statisticsDataProvider = StateNotifierProvider<StatisticsDataNotifier, StatisticsState>(
  (ref) => StatisticsDataNotifier(ref.read(transactionItemsRepoProvider)),
);

class StatisticsDataNotifier extends StateNotifier<StatisticsState> {
  StatisticsDataNotifier(this.transactionItemsRepository) : super(const StatisticsState()) {
    getTransactionItems(DateTime.now().year);
  }

  final TransactionItemsRepository transactionItemsRepository;

  Future<void> getTransactionItems([num? seasonYear]) async {
    // state = state.copyWith(modelState: ModelState.loading);
    // try {
    //   await transactionItemsRepository.getTransactionItems().then((data) async {
    //
    //     state = state.copyWith();
    //
    //   });
    // } catch (e) {
    //   state = state.copyWith(modelState: ModelState.error);
    // }
  }
}
