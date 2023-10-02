import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_service.dart';
import 'package:work_hu/features/create_transactions/data/api/create_transaction_api.dart';
import 'package:work_hu/features/create_transactions/data/models/transaction_item_model.dart';
import 'package:work_hu/features/create_transactions/data/repository/create_transaction_repository.dart';
import 'package:work_hu/features/create_transactions/data/state/create_transactions_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

import '../../../work_hu_app.dart';

final createTransactionsApiProvider = Provider<CreateTransactionsApi>((ref) => CreateTransactionsApi());
//
final createTransactionsRepoProvider = Provider<CreateTransactionsRepository>(
    (ref) => CreateTransactionsRepository(ref.read(createTransactionsApiProvider)));

final createTransactionsDataProvider =
    StateNotifierProvider.autoDispose<CreateTransactionsDataNotifier, CreateTransactionsState>((ref) =>
        CreateTransactionsDataNotifier(
            ref.read(createTransactionsRepoProvider), ref.read(routerProvider), ref.read(usersRepoProvider)));

class CreateTransactionsDataNotifier extends StateNotifier<CreateTransactionsState> {
  CreateTransactionsDataNotifier(this.createTransactionsRepository, this.router, this.usersRepository)
      : super(const CreateTransactionsState()) {
    valueController = TextEditingController(text: "");

    valueController.addListener(_updateState);
  }

  final CreateTransactionsRepository createTransactionsRepository;
  final UsersRepository usersRepository;
  final GoRouter router;
  late final TextEditingController valueController;

  Future<void> getUsers(
      {required num transactionId,
      required TransactionType transactionType,
      required Account account,
      bool? listO36,
      required String description}) async {
    var user = locator<UserService>().currentUser;
    state = state.copyWith(
        modelState: ModelState.processing,
        transactionId: transactionId,
        transactionType: transactionType,
        description: description,
        account: account);
    try {
      await usersRepository
          .getUsers(transactionType == TransactionType.VAER_ET_FORBILDE ? user!.team : null, listO36)
          .then((data) {
        account == Account.OTHER && transactionType == TransactionType.VAER_ET_FORBILDE
            ? _createTransactionItems(data)
            : [];
        state = state.copyWith(
          modelState: ModelState.success,
          users: data,
        );
      });
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }

  Future<void> sendTransactions() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await createTransactionsRepository
          .sendTransactions(state.transactionItems
              .where((element) => element.points != 0 || element.hours != 0 || element.credit != 0)
              .toList())
          .then((data) {
        state = state.copyWith(modelState: ModelState.success);
        if (router.canPop()) {
          router.pop(true);
        }
      });
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }

  update({required num userId, num? hours, double? points, num? credits}) {
    TransactionItemModel? transactionItem = state.transactionItems.firstWhere((t) => t.userId == userId);
    var newItem = transactionItem.copyWith(
        hours: hours ?? transactionItem.hours,
        points: points ?? transactionItem.points,
        credit: credits ?? transactionItem.credit);

    state =
        state.copyWith(transactionItems: state.transactionItems.map((e) => e.userId == userId ? newItem : e).toList());
  }

  void _createTransactionItems(List<UserModel> users) {
    for (UserModel u in users) {
      state = state.copyWith(selectedUser: u);
      addTransaction();
    }
  }

  addTransaction({String? description}) {
    var transactions = <TransactionItemModel>[];
    transactions.addAll(state.transactionItems);
    transactions.add(TransactionItemModel(
      transactionId: state.transactionId,
      transactionDate: DateTime.now(),
      description: description ?? state.description,
      userId: state.selectedUser!.id,
      createUserId: locator<UserService>().currentUser!.id,
      points: state.transactionType != TransactionType.CREDIT && state.transactionType != TransactionType.HOURS
          ? double.tryParse(valueController.value.text) ?? 0
          : 0,
      transactionType: state.transactionType,
      account: state.account,
      credit: state.transactionType == TransactionType.CREDIT ? num.tryParse(valueController.value.text) ?? 0 : 0,
      hours: state.transactionType == TransactionType.HOURS ? num.tryParse(valueController.value.text) ?? 0 : 0,
    ));

    var text = valueController.value.text;
    var sum = state.sum + num.parse(text.isNotEmpty ? text : "0");
    state = state.copyWith(transactionItems: transactions, sum: sum);
    _clearAddFields();
  }

  bool isEmpty() {
    return state.transactionItems
            .indexWhere((element) => element.points != 0 || element.hours != 0 || element.credit != 0) <
        0;
  }

  _clearAddFields() {
    valueController.clear();
    state = state.copyWith(selectedUser: null);
  }

  _updateState() {
    state = state.copyWith();
  }

  updateSelectedUser(UserModel? u) {
    state = state.copyWith(selectedUser: u);
  }
}
