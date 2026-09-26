import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/transaction_items/data/api/transaction_items_api.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_items_filter.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/data/state/transaction_items_state.dart';
import 'package:work_hu/features/transactions/data/repository/transactions_repository.dart';
import 'package:work_hu/features/transactions/providers/transactions_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

import '../../../app/data/models/transaction_type.dart';
import '../../utils.dart';

final transactionItemsApiProvider = Provider<TransactionItemsApi>((ref) => TransactionItemsApi());

final transactionItemsRepoProvider =
    Provider<TransactionItemsRepository>((ref) => TransactionItemsRepository(ref.read(transactionItemsApiProvider)));

final transactionItemsDataProvider = StateNotifierProvider.autoDispose<TransactionItemsDataNotifier, TransactionItemsState>(
    (ref) => TransactionItemsDataNotifier(ref.read(transactionItemsRepoProvider), ref.read(usersRepoProvider),
        ref.read(userDataProvider).user, ref.read(transactionsRepoProvider)));

class TransactionItemsDataNotifier extends StateNotifier<TransactionItemsState> {
  TransactionItemsDataNotifier(
      this.transactionItemsRepository, this.usersRepository, this.currentUser, this.transactionsRepository)
      : super(const TransactionItemsState());

  final TransactionItemsRepository transactionItemsRepository;
  final TransactionRepository transactionsRepository;
  final UsersRepository usersRepository;
  final UserModel? currentUser;

  Future<void> getTransactionItems(num transactionId) async {
    var sort = SortBuilder()
      ..add("user.lastname", descending: false)
      ..add("user.firstname", descending: false);
    await transactionItemsRepository
        .getTransactionItems(filter: TransactionItemsFilter(transactionId: transactionId), page: 0, size: 50, sort: sort.build())
        .then((data) async {
      state = state.copyWith(transactionItems: data.content);
    });
  }

  Future<void> getTransaction(num transactionId) async {
    await transactionsRepository.getTransaction(transactionId).then((data) async {
      state = state.copyWith(transaction: data);
      getTransactionItems(transactionId);
    });
  }

  Future<void> deleteTransactionItem(num id, int index) async {
    await transactionItemsRepository.deleteTransactionItem(id, currentUser!.id).then((data) {
      List<TransactionItemModel> items = state.transactionItems.where((element) => element.id != id).toList();
      state = state.copyWith(transactionItems: items);
    });
  }

  Future<void> createCreditsCsv() async {
    var list = <TransactionItemModel>[];
    DateTime date = DateTime.now();
    String desc = "";
    var users = <UserModel>[];
    for (var item in state.transactionItems) {
      users.add(await usersRepository.getUserById(item.userId));
      date = item.transactionDate;
      desc = item.description;
      list.add(TransactionItemModel(
          transactionDate: item.transactionDate,
          description: item.description,
          createUserId: item.createUserId,
          points: item.hours * 4,
          transactionType: item.transactionType,
          account: item.account,
          credit: item.transactionType == TransactionType.DUKA_MUNKA
              ? item.hours * 1000
              : item.transactionType == TransactionType.DUKA_MUNKA_2000
                  ? item.hours * 2000
                  : item.transactionType == TransactionType.HOURS
                      ? item.hours * 3000
                      : item.transactionType == TransactionType.POINT
                          ? 0
                          : item.transactionType == TransactionType.CREDIT
                              ? item.credit
                              : 0,
          hours: item.hours,
          userName: item.userName,
          userId: item.userId));
    }
    Utils.createCreditCsv(list, date, desc, users);
  }
}
