import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/transaction_items/data/api/transaction_items_api.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
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
        ref.read(userDataProvider.notifier), ref.read(transactionsRepoProvider)));

class TransactionItemsDataNotifier extends StateNotifier<TransactionItemsState> {
  TransactionItemsDataNotifier(
      this.transactionItemsRepository, this.usersRepository, this.currentUserProvider, this.transactionsRepository)
      : super(const TransactionItemsState());

  final TransactionItemsRepository transactionItemsRepository;
  final TransactionRepository transactionsRepository;
  final UsersRepository usersRepository;
  final UserDataNotifier currentUserProvider;

  Future<void> getTransactionItems(num transactionId) async {
    state = state.copyWith(modelState: ModelState.processing, transactionItems: []);
    try {
      await transactionItemsRepository.getTransactionItems(transactionId: transactionId).then((data) async {
        data.sort((a, b) => b.user.lastname.compareTo(a.user.lastname));
        state = state.copyWith(transactionItems: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> getTransaction(num transactionId) async {
    state = state.copyWith(modelState: ModelState.processing, transactionItems: []);
    try {
      await transactionsRepository.getTransaction(transactionId).then((data) async {
        state = state.copyWith(transaction: data, modelState: ModelState.success);
        getTransactionItems(transactionId);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> deleteTransactionItem(num id, int index) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await transactionItemsRepository.deleteTransactionItem(id, currentUserProvider.state!.id).then((data) {
        List<TransactionItemModel> items = state.transactionItems.where((element) => element.id != id).toList();
        state = state.copyWith(transactionItems: items, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> createCreditsCsv() async {
    var list = <TransactionItemModel>[];
    DateTime date = DateTime.now();
    String desc = "";
    for (var item in state.transactionItems) {
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
          user: item.user));
    }
    Utils.createCreditCsv(list, date, desc);
  }
}
