import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/activity_items/data/api/activity_items_api.dart';
import 'package:work_hu/features/activity_items/data/repository/activity_items_repository.dart';
import 'package:work_hu/features/activity_items/data/state/activity_items_state.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/utils.dart';

final activityItemsApiProvider = Provider<ActivityItemsApi>((ref) => ActivityItemsApi());

final activityItemsRepoProvider =
    Provider<ActivityItemsRepository>((ref) => ActivityItemsRepository(ref.read(activityItemsApiProvider)));

final activityItemsDataProvider = StateNotifierProvider.autoDispose<ActivityItemsDataNotifier, ActivityItemsState>(
    (ref) => ActivityItemsDataNotifier(ref.read(activityItemsRepoProvider), ref.read(userDataProvider.notifier)));

class ActivityItemsDataNotifier extends StateNotifier<ActivityItemsState> {
  ActivityItemsDataNotifier(
    this.activityRepository,
    this.currentUserProvider,
  ) : super(const ActivityItemsState());

  final ActivityItemsRepository activityRepository;
  final UserDataNotifier currentUserProvider;

  Future<void> getActivityItems({required num activityId}) async {
    state = state.copyWith(modelState: ModelState.processing, activityId: activityId);
    try {
      await activityRepository.getActivityItems(activityId: activityId).then((data) async {
        state = state.copyWith(activityItems: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> deleteActivityItem(num num, int index) async {}

  Future<void> createActivityXlsx() async {
    Utils.createActivityXlsx(state.activityItems, state.activityItems.first.activity!);
  }

  Future<void> createCreditCsv() async {
    var list = <TransactionItemModel>[];
    for (var item in state.activityItems) {
      list.add(TransactionItemModel(
          transactionDate: item.activity!.activityDateTime,
          description: item.description,
          createUserId: item.createUser.id,
          points: item.hours * 4,
          transactionType: item.transactionType,
          account: item.account,
          credit: item.transactionType == TransactionType.DUKA_MUNKA ? item.hours * 1000 : item.hours * 2000,
          hours: item.hours,
          user: item.user));
    }
    Utils.createCreditCsv(
        list, state.activityItems.first.activity!.activityDateTime, state.activityItems.first.activity!.description);
  }
}
