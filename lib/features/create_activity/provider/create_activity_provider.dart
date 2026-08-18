import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
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
import 'package:work_hu/features/round_filter_chip/data/state/round_filter_chip_state.dart';
import 'package:work_hu/features/round_filter_chip/providers/round_filter_chip_provider.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';

final createActivityDataProvider = StateNotifierProvider.autoDispose<CreateActivityDataNotifier, CreateActivityState>((ref) =>
    CreateActivityDataNotifier(ref.read(userDataProvider).user, ref.read(activityRepoProvider),
        ref.read(activityItemsRepoProvider), ref.read(roundFilterChipDataProvider.notifier)));

class CreateActivityDataNotifier extends BaseDataNotifier<CreateActivityState> {
  CreateActivityDataNotifier(this.currentUser, this.activityRepository, this.activityItemsRepository, this.roundDataNotifier)
      : super(const CreateActivityState());

  final UserModel? currentUser;
  final RoundFilterChipDataNotifier roundDataNotifier;

  final ActivityRepository activityRepository;
  final ActivityItemsRepository activityItemsRepository;

  void updateActivity(ActivityModel activity) {
    activity = activity.copyWith(transactionType: activity.employerId != 281 ? TransactionType.HOURS : activity.transactionType);
    state = state.copyWith(activity: activity);
    _updateItems();
  }

  void updateHours(String text) {
    state = state.copyWith(hours: double.tryParse(text));
  }

  void updateDefaultHour(String text) {
    state = state.copyWith(defaultHour: double.tryParse(text) ?? 0);
  }

  Future<void> addRegistration({String? description, required double hours}) async {
    var registration = ActivityItemsModel(
      description: description ?? state.activity!.description,
      userId: state.selectedUser!.id,
      roundId: (await roundDataNotifier.getCurrentRound()).id,
      transactionType: state.activity!.transactionType,
      account: state.activity!.account,
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

  Future<void> deleteRegistration(int index) async {
    List<ActivityItemsModel> items = [];
    var item = state.activityItems[index];
    var value = item.hours;

    if (item.id != null) {
      await executeApiCall(() => activityItemsRepository.deleteActivityItems(item.id!));
    }

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

  updateAccount(TransactionType transactionTye) {
    var account = transactionTye == TransactionType.POINT ? Account.OTHER : Account.MYSHARE;
    state = state.copyWith(activity: state.activity!.copyWith(account: account, transactionType: transactionTye));
    _updateItems();
  }

  _updateItems() {
    List<ActivityItemsModel> items = [];
    items.addAll(state.activityItems);
    List<ActivityItemsModel> newItems = [];
    for (var item in items) {
      newItems.add(item.copyWith(
          account: state.activity!.account,
          transactionType: state.activity!.transactionType,
          description: state.activity!.description));
    }

    state = state.copyWith(activityItems: newItems);
  }

  Future<void> sendActivity() async {
    if (state.activity!.id != null) {
      await executeApiCall<ActivityModel>(() => activityRepository.putActivity(state.activity!, state.activity!.id!),
          onSuccess: (activity) async {
        await sendActivityItems(activity.id!);
      });
    } else {
      await executeApiCall<ActivityModel>(() => activityRepository.postActivity(state.activity!), onSuccess: (activity) async {
        await sendActivityItems(activity.id!);
      });
    }
  }

  Future<void> sendActivityItems(num activityId) async {
    List<ActivityItemsModel> newItems = [];
    for (var item in state.activityItems) {
      newItems.add(item.copyWith(activityId: activityId));
    }
    await executeApiCall(
        () => activityItemsRepository.postActivityItems(newItems.where((element) => element.hours != 0).toList()));
  }

  @override
  CreateActivityState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }

  Future<void> getActivity(num id) async {
    await executeApiCall<ActivityModel>(() => activityRepository.getActivity(id), onSuccess: (activity) async {
      var items = await getActivityItems(id);
      state = state.copyWith(activity: activity, activityItems: items.content);
    });
  }

  void presetActivity() {
    ActivityModel activity = ActivityModel(
        createUserId: currentUser!.id,
        createUserName: '',
        description: '',
        activityDateTime: DateTime.now(),
        employerId: 281,
        employerName: '',
        responsibleId: currentUser!.id,
        responsibleName: '',
        registeredInApp: false,
        registeredInMyShare: false,
        registeredInTeams: false,
        transactionType: TransactionType.DUKA_MUNKA_2000,
        account: Account.MYSHARE);
    state = state.copyWith(activity: activity);
  }

  Future<PaginatedResponse<ActivityItemsModel>> getActivityItems(num activityId) async {
    return await executeApiCall<PaginatedResponse<ActivityItemsModel>>(
        () => activityItemsRepository.getActivityItems(activityId: activityId));
  }
}
