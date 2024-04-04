import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/transactions/data/api/transaction_api.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/repository/transactions_repository.dart';
import 'package:work_hu/features/transactions/data/state/transactions_state.dart';

final transactionsApiProvider = Provider<TransactionApi>((ref) => TransactionApi());

final transactionsRepoProvider =
    Provider<TransactionRepository>((ref) => TransactionRepository(ref.read(transactionsApiProvider)));

final transactionsDataProvider = StateNotifierProvider.autoDispose<TransactionsDataNotifier, TransactionsState>((ref) =>
    TransactionsDataNotifier(
        ref.read(transactionsRepoProvider), ref.read(userDataProvider.notifier), ref.read(roundDataProvider.notifier)));

class TransactionsDataNotifier extends StateNotifier<TransactionsState> {
  TransactionsDataNotifier(this.transactionRepository, this.currentUserProvider, this.roundProvider)
      : super(const TransactionsState()) {
    getRounds();
  }

  final TransactionRepository transactionRepository;
  final UserDataNotifier currentUserProvider;
  final RoundDataNotifier roundProvider;

  Future<void> getTransactions() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await transactionRepository.getTransactions(state.selectedRoundId).then((data) {
        data.sort((a, b) =>
            a.createDateTime != null && b.createDateTime != null ? b.createDateTime!.compareTo(a.createDateTime!) : 0);
        state = state.copyWith(transactions: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> deleteTransaction(num id, int index) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await transactionRepository.deleteTransaction(id, currentUserProvider.state!.id).then((data) {
        List<TransactionModel> items = [];
        for (var i = 0; i < state.transactions.length; i++) {
          if (i != index) items.add(state.transactions[i]);
        }
        state = state.copyWith(transactions: items, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> getRounds() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      var rounds = await roundProvider.roundRepository.getRounds();
      var currentRound = await roundProvider.roundRepository.getCurrentRounds();
      state = state.copyWith(rounds: rounds, selectedRoundId: currentRound.id, modelState: ModelState.success);
      await getTransactions();
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> setSelectedRound(num roundId) async {
    state = state.copyWith(selectedRoundId: roundId);
    await getTransactions();
  }
}
