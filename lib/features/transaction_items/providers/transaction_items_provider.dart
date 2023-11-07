import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
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
      await transactionRepository.getTransactionItems(transactionId: transactionId).then((data) async {
        data.sort((a, b) => b.user.lastname.compareTo(a.user.lastname));
        state = state.copyWith(transactionItems: data, modelState: ModelState.success);
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

  Future<void> createCreditsCsv() async {
    var headers = [
      "ACTIVITYID",
      "HOURREGID",
      "PERSONID",
      "LASTNAME",
      "FIRSTNAME",
      "AGE",
      "DATE",
      "HOURS",
      "STARTTIME",
      "ENDTIME",
      "PAUSE",
      "CLUBNAME",
      "CLUBID"
    ];

    List<List<dynamic>> list = [];
    list.add(headers);
    var items = state.transactionItems;
    for (var transaction in items) {
      list.add([
        440104,
        0,
        transaction.user.myShareID,
        transaction.user.lastname,
        transaction.user.firstname,
        (DateTime.now().difference(transaction.user.birthDate).inDays / 365).ceil() - 1,
        '${transaction.transactionDate.day}/${transaction.transactionDate.month}/${transaction.transactionDate.year}',
        transaction.hours,
        "10:00",
        "10:00",
        0,
        "BUK Vácduka",
        3964
      ]);
    }
    String csv = const ListToCsvConverter().convert(list);
    Uint8List bytes = Uint8List.fromList(utf8.encode(csv));

    await FileSaver.instance.saveFile(
      name: 'document_name',
      bytes: bytes,
      ext: 'csv',
      mimeType: MimeType.csv,
    );
  }
}
