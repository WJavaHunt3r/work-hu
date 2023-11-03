import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/transaction_items/data/api/transaction_items_api.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/data/state/transaction_items_state.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final transactionItemsApiProvider = Provider<TransactionItemsApi>((ref) => TransactionItemsApi());

final transactionItemsRepoProvider =
    Provider<TransactionItemsRepository>((ref) => TransactionItemsRepository(ref.read(transactionItemsApiProvider)));

final transactionItemsDataProvider =
    StateNotifierProvider.autoDispose<TransactionItemsDataNotifier, TransactionItemsState>((ref) =>
        TransactionItemsDataNotifier(
            ref.read(transactionItemsRepoProvider), ref.read(usersRepoProvider), ref.read(userDataProvider.notifier)));

class TransactionItemsDataNotifier extends StateNotifier<TransactionItemsState> {
  TransactionItemsDataNotifier(this.transactionRepository, this.usersRepository, this.currentUserProvider)
      : super(const TransactionItemsState());

  final TransactionItemsRepository transactionRepository;
  final UsersRepository usersRepository;
  final UserDataNotifier currentUserProvider;

  Future<void> getTransactionItems(num transactionId) async {
    state = state.copyWith(modelState: ModelState.processing, transactionItems: []);
    try {
      List<TransactionItemModel> items = [];
      await transactionRepository.getTransactionItems(transactionId: transactionId).then((data) async {
        for (TransactionItemModel item in data) {
          await usersRepository.getUserById(item.userId).then((user) => items.add(item.copyWith(user: user)));
        }
        items.sort((a, b) => b.user!.lastname.compareTo(a.user!.lastname));
        state = state.copyWith(transactionItems: items, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> deleteTransactionItem(num id, int index) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await transactionRepository.deleteTransactionItem(id, currentUserProvider.state!.id).then((data) {
        List<TransactionItemModel> items = state.transactionItems.where((element) => element.id != id).toList();
        state = state.copyWith(transactionItems: items, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }
}
