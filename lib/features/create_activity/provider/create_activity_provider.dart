import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/data/repository/activity_repository.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/activity_items/data/repository/activity_items_repository.dart';
import 'package:work_hu/features/activity_items/provider/activity_items_provider.dart';
import 'package:work_hu/features/create_activity/data/state/create_activity_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';
import 'package:work_hu/work_hu_app.dart';

final createActivityDataProvider = StateNotifierProvider.autoDispose<CreateActivityDataNotifier, CreateActivityState>(
    (ref) => CreateActivityDataNotifier(
        ref.read(routerProvider),
        ref.read(usersRepoProvider),
        ref.read(userDataProvider.notifier),
        ref.read(activityRepoProvider),
        ref.read(activityItemsRepoProvider),
        ref.read(roundDataProvider.notifier)));

class CreateActivityDataNotifier extends StateNotifier<CreateActivityState> {
  CreateActivityDataNotifier(this.router, this.usersRepository, this.currentUserProvider, this.activityRepository,
      this.activityItemsRepository, this.roundDataNotifier)
      : super(const CreateActivityState()) {
    hoursController = TextEditingController(text: "");
    userController = TextEditingController(text: "");
    employerController = TextEditingController(text: "");
    responsibleController = TextEditingController(text: "");
    descriptionController = TextEditingController(text: "");
    dateController = TextEditingController(text: DateTime.now().toString());
    valueFocusNode = FocusNode();
    usersFocusNode = FocusScopeNode();

    descriptionController.addListener(_updateDescription);
    dateController.addListener(_updateDate);
    hoursController.addListener(_updateState);
    userController.addListener(_collapsePanel);
    getUsers();
  }

  final UsersRepository usersRepository;
  final GoRouter router;
  final UserDataNotifier currentUserProvider;
  final RoundDataNotifier roundDataNotifier;
  late final TextEditingController hoursController;
  late final TextEditingController descriptionController;
  late final TextEditingController dateController;
  late final TextEditingController userController;
  late final TextEditingController responsibleController;
  late final TextEditingController employerController;
  final ActivityRepository activityRepository;
  final ActivityItemsRepository activityItemsRepository;
  late final FocusNode valueFocusNode;
  late final FocusScopeNode usersFocusNode;

  Future<void> getUsers({bool? listO36}) async {
    var user = currentUserProvider.state;
    updateResponsible(user!);

    state = state.copyWith(modelState: ModelState.processing);
    try {
      await usersRepository.getUsers(null, true).then((data) {
        state = state.copyWith(
          modelState: ModelState.success,
          users: data,
        );
        updateAccount(false);
      });
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, errorMessage: e.message);
    }
  }

  void _updateDate() {
    state = state.copyWith(activityDate: DateTime.tryParse(dateController.value.text));
    _updateItems();
  }

  void _updateDescription() {
    state = state.copyWith(description: descriptionController.value.text);
    _updateItems();
  }

  setTransactionTypeAndAccount(TransactionType transactionType, Account account) {
    state = state.copyWith(transactionType: transactionType, account: account);
  }

  addRegistration({String? description}) {
    var registration = ActivityItemsModel(
      description: description ?? state.description,
      user: state.selectedUser!,
      round: roundDataNotifier.state.rounds.where((element) => element.season.seasonYear == DateTime.now().year).first,
      transactionType: state.transactionType,
      account: state.account,
      hours: double.tryParse(hoursController.value.text) ?? 0,
      createUser: currentUserProvider.state!,
    );

    var text = hoursController.value.text;
    var sum = state.sum + num.parse(text.isNotEmpty ? text : "0");

    var items = <ActivityItemsModel>[];
    items.addAll(state.activityItems);
    items.add(registration);
    state = state.copyWith(activityItems: items, sum: sum, modelState: ModelState.empty);
    _clearAddFields();
    usersFocusNode.requestFocus();
  }

  deleteRegistration(int index) {
    List<ActivityItemsModel> items = [];
    var item = state.activityItems[index];
    var value = item.hours;

    for (var i = 0; i < state.activityItems.length; i++) {
      if (i != index) items.add(state.activityItems[i]);
    }

    state = state.copyWith(activityItems: items, sum: state.sum - value);
    _clearAddFields();
  }

  bool isEmpty() {
    return state.activityItems.indexWhere((e) => e.hours != 0) < 0;
  }

  _clearAddFields() {
    hoursController.clear();
    userController.clear();
    state = state.copyWith(selectedUser: null);
  }

  updateCollapsed(bool collapsed) {
    state = state.copyWith(isCollapsed: collapsed);
  }

  _updateState() {
    state = state.copyWith();
  }

  updateSelectedUser(UserModel? u) {
    valueFocusNode.requestFocus();
    userController.text = "${u?.getFullName()} (${u?.getAge()}) ";
    state = state.copyWith(selectedUser: u);
  }

  updateEmployer(UserModel u) {
    employerController.text = "${u.getFullName()} (${u.getAge()}) ";
    state = state.copyWith(employer: u);
  }

  updateResponsible(UserModel u) {
    responsibleController.text = "${u.getFullName()} (${u.getAge()}) ";
    state = state.copyWith(responsible: u);
  }

  updateAccount(bool isPaid) {
    if (!isPaid) {
      updateEmployer(
          state.users.firstWhere((element) => element.myShareID == 0, orElse: () => currentUserProvider.state!));
    } else {
      employerController.text = "";
      state = state.copyWith(employer: null);
    }
    var account = isPaid ? Account.MYSHARE : Account.OTHER;
    var trType = isPaid ? TransactionType.HOURS : TransactionType.POINT;
    state = state.copyWith(account: account, transactionType: trType);
    _updateItems();
  }

  _updateItems() {
    List<ActivityItemsModel> items = [];
    items.addAll(state.activityItems);
    List<ActivityItemsModel> newItems = [];
    for (var item in items) {
      newItems.add(item.copyWith(
          account: state.account, transactionType: state.transactionType, description: state.description));
    }

    state = state.copyWith(activityItems: newItems);
  }

  Future<List<UserModel>> filterUsers(String filter) async {
    var filtered = state.users
        .where((u) =>
            Utils.changeSpecChars(u.firstname.toLowerCase()).startsWith(Utils.changeSpecChars(filter.toLowerCase())) ||
            Utils.changeSpecChars(u.lastname.toLowerCase()).startsWith(Utils.changeSpecChars(filter.toLowerCase())))
        .toList();
    filtered.sort((a, b) => (a.getFullName()).compareTo(b.getFullName()));
    return filtered;
  }

  Future<void> sendActivity() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await activityRepository
          .postActivity(ActivityModel(
              description: descriptionController.value.text,
              account: state.account,
              createUser: currentUserProvider.state!,
              activityDateTime: DateTime.parse(dateController.value.text),
              employer: state.employer!,
              responsible: state.responsible!,
              registeredInApp: false,
              registeredInMyShare: false,
              transactionType: state.transactionType))
          .then((activity) async {
        List<ActivityItemsModel> newItems = [];
        for (var item in state.activityItems) {
          newItems.add(item.copyWith(activity: activity));
        }
        state = state.copyWith(activityItems: newItems);
        await activityItemsRepository
            .postActivityItems(newItems.where((element) => element.hours != 0).toList())
            .then((data) {
          Utils.createActivityXlsx(newItems, activity);
          pop();
          state = state.copyWith(creationState: ModelState.success, modelState: ModelState.success, errorMessage: data);
        });
      });
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, errorMessage: e.message);
    }
  }

  void _collapsePanel() {
    if (state.isCollapsed && userController.value.text.isNotEmpty) {
      state = state.copyWith(isCollapsed: false);
    }
  }

  void pop() {
    router.pop();
  }
}
