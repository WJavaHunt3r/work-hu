import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/transactions/data/api/transaction_api.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/repository/transactions_repository.dart';
import 'package:work_hu/features/transactions/data/state/transactions_state.dart';

final transactionsApiProvider = Provider<TransactionApi>((ref) => TransactionApi());

final transactionsRepoProvider =
    Provider<TransactionRepository>((ref) => TransactionRepository(ref.read(transactionsApiProvider)));

final transactionsDataProvider = StateNotifierProvider.autoDispose<TransactionsDataNotifier, TransactionsState>(
    (ref) => TransactionsDataNotifier(ref.read(transactionsRepoProvider), ref.read(userDataProvider.notifier)));

class TransactionsDataNotifier extends StateNotifier<TransactionsState> {
  TransactionsDataNotifier(this.transactionRepository, this.currentUserProvider) : super(const TransactionsState()) {
    getTransactions();
  }

  final TransactionRepository transactionRepository;
  final UserDataNotifier currentUserProvider;

  Future<void> getTransactions() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await transactionRepository.getTransactions().then((data) {
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
}
