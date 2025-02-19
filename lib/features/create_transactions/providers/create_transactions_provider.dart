import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/create_transactions/data/state/create_transactions_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/repository/transactions_repository.dart';
import 'package:work_hu/features/transactions/providers/transactions_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

final createTransactionsDataProvider = StateNotifierProvider.autoDispose<
        CreateTransactionsDataNotifier, CreateTransactionsState>(
    (ref) => CreateTransactionsDataNotifier(
        ref.read(usersRepoProvider),
        ref.read(userDataProvider.notifier),
        ref.read(transactionsRepoProvider),
        ref.read(transactionItemsRepoProvider),
        ref.read(roundDataProvider.notifier)));

class CreateTransactionsDataNotifier
    extends StateNotifier<CreateTransactionsState> {
  CreateTransactionsDataNotifier(
      this.usersRepository,
      this.currentUserProvider,
      this.transactionRepository,
      this.transactionItemsRepository,
      this.roundDataNotifier)
      : super(const CreateTransactionsState()) {
    valueController = TextEditingController(text: "");
    userController = TextEditingController(text: "");
    exchangeController = TextEditingController(text: "33");
    descriptionController = TextEditingController(text: "");
    dateController = TextEditingController(text: DateTime.now().toString());
    valueFocusNode = FocusNode();
    usersFocusNode = FocusScopeNode();

    descriptionController.addListener(_updateDateAndDescription);
    dateController.addListener(_updateDateAndDescription);
    exchangeController.addListener(_updateState);
    valueController.addListener(_updateState);
    getUsers();
  }

  final UsersRepository usersRepository;
  final UserDataNotifier currentUserProvider;
  final RoundDataNotifier roundDataNotifier;
  late final TextEditingController valueController;
  late final TextEditingController exchangeController;
  late final TextEditingController descriptionController;
  late final TextEditingController dateController;
  late final TextEditingController userController;
  final TransactionRepository transactionRepository;
  final TransactionItemsRepository transactionItemsRepository;
  late final FocusNode valueFocusNode;
  late final FocusScopeNode usersFocusNode;

  Future<void> getUsers({bool? listO36}) async {
    var user = currentUserProvider.state;
    // var date = DateFormat("yyyy-MM-dd").parse(
    //     transactionDate == null || transactionDate.isEmpty ? DateTime.now().toLocal().toString() : transactionDate);
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await usersRepository
          .getUsers(
              state.transactionType == TransactionType.BMM_PERFECT_WEEK
                  ? user!.paceTeam
                  : null,
              listO36)
          .then((data) {
        state.account == Account.OTHER &&
                state.transactionType == TransactionType.BMM_PERFECT_WEEK
            ? _createTransactionItems(data)
            : _clearTransactions();
        state = state.copyWith(
          modelState: ModelState.success,
          creationState: ModelState.empty,
          users: data,
        );
      });
    } on DioException catch (e) {
      state =
          state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> sendTransactions() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await transactionRepository
          .createTransaction(
              TransactionModel(
                name: state.account == Account.OTHER &&
                        state.transactionType ==
                            TransactionType.BMM_PERFECT_WEEK
                    ? "${currentUserProvider.state!.paceTeam!.teamName} csapat tökéletes pontszámai"
                    : descriptionController.value.text,
                account: state.account,
              ),
              currentUserProvider.state?.id ?? 0)
          .then((data) async {
        List<TransactionItemModel> newItems = [];
        for (var item in state.transactionItems) {
          newItems.add(item.copyWith(
              transactionId: data.id!,
              transactionDate: DateTime.parse(dateController.value.text)));
        }
        state = state.copyWith(transactionItems: newItems);
        await transactionItemsRepository
            .sendTransactions(newItems
                .where((element) =>
                    element.points != 0 ||
                    element.hours != 0 ||
                    element.credit != 0)
                .toList())
            .then((data) {
          if (state.account == Account.OTHER &&
              state.transactionType == TransactionType.BMM_PERFECT_WEEK) {
            _clearAllFields();
            _createTransactionItems(state.users);
          } else {
            _clearAllFields();
          }

          state = state.copyWith(
              modelState: ModelState.success,
              creationState: ModelState.success);
        });
      });
    } on DioException catch (e) {
      state =
          state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  void _updateDateAndDescription() {
    state = state.copyWith(
        transactionDate: DateTime.tryParse(dateController.value.text),
        description: descriptionController.value.text);
  }

  setTransactionTypeAndAccount(
      TransactionType transactionType, Account account) {
    state = state.copyWith(transactionType: transactionType, account: account);
  }

  update({required num userId, double? hours, double? points, num? credits}) {
    TransactionItemModel? transactionItem =
        state.transactionItems.firstWhere((t) => t.user.id == userId);
    var newItem = transactionItem.copyWith(
        hours: hours ?? transactionItem.hours,
        points: points ?? transactionItem.points,
        credit: credits ?? transactionItem.credit);

    state = state.copyWith(
        transactionItems: state.transactionItems
            .map((e) => e.user.id == userId ? newItem : e)
            .toList(),
        creationState: ModelState.empty);
  }

  void _createTransactionItems(List<UserModel> users) {
    for (UserModel u in users) {
      state = state.copyWith(selectedUser: u);
      addTransaction(
          description:
              "${currentUserProvider.state!.paceTeam!.teamName} csapat tökéletes BMM hét");
    }
  }

  addTransaction({String? description}) {
    if (state.account == Account.SAMVIRK &&
        num.parse(valueController.value.text) <= 3000) {
      state = state.copyWith(
          modelState: ModelState.error,
          message: "Must be greater than 3000 HUF");
    } else {
      var transactions = <TransactionItemModel>[];
      transactions.addAll(state.transactionItems);
      transactions.add(TransactionItemModel(
        transactionId: 0,
        transactionDate:
            DateUtils.dateOnly(state.transactionDate ?? DateTime.now()),
        description: state.description,
        user: state.selectedUser!,
        createUserId: currentUserProvider.state!.id,
        round: roundDataNotifier.getCurrentRound(),
        points: state.transactionType != TransactionType.CREDIT &&
                state.transactionType != TransactionType.HOURS
            ? double.tryParse(valueController.value.text) ?? 0
            : 0,
        transactionType: state.transactionType,
        account: state.account,
        credit: state.transactionType == TransactionType.CREDIT
            ? num.tryParse(valueController.value.text) ?? 0
            : 0,
        hours: state.transactionType == TransactionType.HOURS
            ? double.tryParse(valueController.value.text) ?? 0
            : 0,
      ));

      var text = valueController.value.text;
      var sum = state.sum + num.parse(text.isNotEmpty ? text : "0");
      state = state.copyWith(
          transactionItems: transactions,
          sum: sum,
          modelState: ModelState.empty);
      _clearAddFields();
      usersFocusNode.requestFocus();
    }
  }

  deleteTransaction(int index) {
    List<TransactionItemModel> items = [];
    var item = state.transactionItems[index];
    var value = item.credit + item.hours + item.points;

    for (var i = 0; i < state.transactionItems.length; i++) {
      if (i != index) items.add(state.transactionItems[i]);
    }

    state = state.copyWith(transactionItems: items, sum: state.sum - value);
    _clearAddFields();
  }

  bool isEmpty() {
    return state.transactionItems.indexWhere((element) =>
            element.points != 0 || element.hours != 0 || element.credit != 0) <
        0;
  }

  _clearAddFields() {
    valueController.clear();
    userController.clear();
    state = state.copyWith(selectedUser: null, creationState: ModelState.empty);
  }

  _clearTransactions() {
    state = state.copyWith(
        transactionItems: [], sum: 0, creationState: ModelState.empty);
  }

  _updateState() {
    state = state.copyWith();
  }

  updateSelectedUser(UserModel? u) {
    valueFocusNode.requestFocus();
    userController.text = "${u?.getFullName()} ( ${u?.getAge()}) ";
    state = state.copyWith(selectedUser: u);
  }

  Future<List<UserModel>> filterUsers(String filter) async {
    var filtered = state.users
        .where((u) =>
            Utils.changeSpecChars(u.firstname.toLowerCase())
                .startsWith(Utils.changeSpecChars(filter.toLowerCase())) ||
            Utils.changeSpecChars(u.lastname.toLowerCase())
                .startsWith(Utils.changeSpecChars(filter.toLowerCase())))
        .toList();
    filtered.sort((a, b) => (a.getFullName()).compareTo(b.getFullName()));
    return filtered;
  }

  Future<void> createCreditsCsv() async {
    Utils.createCreditCsv(state.transactionItems,
        state.transactionDate ?? DateTime.now(), state.description);
  }

  Future<void> createHoursCsv() async {}

  Future<void> uploadSamvirkCsv() async {
    try {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        withData: true,
      );

      if (pickedFile != null) {
        var file = pickedFile.files.first;

        final input = utf8.decode(file.bytes!);
        final fields = const CsvToListConverter().convert(input);
        var rowNb = 0;
        for (var row in fields) {
          if (rowNb != 0) {
            var field = row[0].split(";");
            var user = state.users.firstWhere(
                (element) => element.myShareID.toString() == field[1]);
            var creditNok = field[5];
            var creditHUF = int.parse(creditNok) *
                double.parse(exchangeController.value.text);
            DateTime date;
            try {
              field[7].split(".");
              date = DateFormat("yyyy.MM.dd").parse(field[7]);
            } catch (e) {
              try {
                date = DateFormat("yyyy/MM/dd").parse(field[7]);
              } catch (e) {
                date = DateTime.now();
              }
            }

            valueController.text = creditHUF.toString();
            state = state.copyWith(selectedUser: user);

            addTransaction(
                description: "Samvirk befizetés ${Utils.dateToString(date)}");
          }
          rowNb++;
        }
      }
    } catch (e) {
      state = state.copyWith(
          modelState: ModelState.error,
          message: "Not supported: ${e.toString()}");
    }
  }

  void _clearAllFields() {
    descriptionController.clear();
    _clearTransactions();
    dateController.text = DateTime.now().toString();
  }
}
