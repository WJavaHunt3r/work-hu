import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/data/repository/activity_repository.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/activity_items/data/repository/activity_items_repository.dart';
import 'package:work_hu/features/activity_items/provider/activity_items_provider.dart';
import 'package:work_hu/features/create_activity/data/state/create_activity_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';

final createActivityDataProvider = StateNotifierProvider.autoDispose<CreateActivityDataNotifier, CreateActivityState>((ref) =>
    CreateActivityDataNotifier(ref.read(userDataProvider).user, ref.read(activityRepoProvider),
        ref.read(activityItemsRepoProvider), ref.read(roundDataProvider.notifier)));

class CreateActivityDataNotifier extends BaseDataNotifier<CreateActivityState> {
  CreateActivityDataNotifier(this.currentUser, this.activityRepository, this.activityItemsRepository, this.roundDataNotifier)
      : super(const CreateActivityState());

  final UserModel? currentUser;
  final RoundDataNotifier roundDataNotifier;

  final ActivityRepository activityRepository;
  final ActivityItemsRepository activityItemsRepository;

  void updateDate(String text) {
    state = state.copyWith(activityDate: DateTime.tryParse(text));
    _updateItems();
  }

  void updateDescription(String text) {
    state = state.copyWith(description: text);
    _updateItems();
  }

  void updateHours(String text) {
    state = state.copyWith(hours: double.tryParse(text));
  }

  setTransactionTypeAndAccount(TransactionType transactionType, Account account) {
    state = state.copyWith(transactionType: transactionType, account: account);
  }

  addRegistration({String? description, required double hours}) {
    var registration = ActivityItemsModel(
      description: description ?? state.description,
      userId: state.selectedUser!.id,
      roundId: roundDataNotifier.getCurrentRound()!.id,
      transactionType: state.transactionType,
      account: state.account,
      hours: hours,
      createUserId: currentUser!.id,
      createUserName: '',
      userName: state.selectedUser?.comboText ?? "",
    );

    var sum = state.sum + hours;

    var items = <ActivityItemsModel>[];
    items.addAll(state.activityItems);
    items.add(registration);
    state = state.copyWith(activityItems: items, sum: sum);
    _clearAddFields();
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
    state = state.copyWith(selectedUser: null, hours: 0);
  }

  updateSelectedUser(UserComboModel? u) {
    state = state.copyWith(selectedUser: u);
  }

  updateEmployer(UserComboModel u) {
    state = state.copyWith(employer: u);
    updateAccount(u.id == 281 ? TransactionType.DUKA_MUNKA : TransactionType.HOURS);
  }

  updateResponsible(UserComboModel u) {
    state = state.copyWith(responsible: u);
  }

  updateAccount(TransactionType transactionTye) {
    var account = transactionTye == TransactionType.POINT ? Account.OTHER : Account.MYSHARE;
    state = state.copyWith(account: account, transactionType: transactionTye);
    _updateItems();
  }

  _updateItems() {
    List<ActivityItemsModel> items = [];
    items.addAll(state.activityItems);
    List<ActivityItemsModel> newItems = [];
    for (var item in items) {
      newItems.add(item.copyWith(account: state.account, transactionType: state.transactionType, description: state.description));
    }

    state = state.copyWith(activityItems: newItems);
  }

  Future<void> sendActivity() async {
    await executeApiCall<ActivityModel>(
        () => activityRepository.postActivity(ActivityModel(
            description: state.description,
            account: state.account,
            createUserId: currentUser!.id,
            activityDateTime: state.activityDate ?? DateTime.now(),
            employerId: state.employer!.id,
            responsibleId: state.responsible!.id,
            registeredInApp: false,
            registeredInMyShare: false,
            transactionType: state.transactionType,
            registeredInTeams: false,
            createUserName: '',
            employerName: '',
            responsibleName: '')), onSuccess: (activity) async {
      List<ActivityItemsModel> newItems = [];
      for (var item in state.activityItems) {
        newItems.add(item.copyWith(activityId: activity.id));
      }
      await executeApiCall(
          () => activityItemsRepository.postActivityItems(newItems.where((element) => element.hours != 0).toList()));
    });
  }

  @override
  CreateActivityState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }
}
