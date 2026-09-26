import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/data/repository/activity_repository.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/activity_items/data/api/activity_items_api.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/activity_items/data/repository/activity_items_repository.dart';
import 'package:work_hu/features/activity_items/data/state/activity_items_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/providers/base_provider.dart';

final activityItemsApiProvider = Provider<ActivityItemsApi>((ref) => ActivityItemsApi());

final activityItemsRepoProvider =
    Provider<ActivityItemsRepository>((ref) => ActivityItemsRepository(ref.read(activityItemsApiProvider)));

final activityItemsDataProvider = StateNotifierProvider.autoDispose<ActivityItemsDataNotifier, ActivityItemsState>((ref) =>
    ActivityItemsDataNotifier(ref.read(activityItemsRepoProvider), ref.read(usersRepoProvider), ref.read(activityRepoProvider)));

class ActivityItemsDataNotifier extends BaseDataNotifier<ActivityItemsState> implements ListApiProvider<num> {
  ActivityItemsDataNotifier(this.activityItemRepository, this._usersRepository, this._activityRepository)
      : super(const ActivityItemsState());

  final ActivityItemsRepository activityItemRepository;
  final ActivityRepository _activityRepository;
  final UsersRepository _usersRepository;

  Future<void> getActivity(num activityId) async {
    executeApiCall<ActivityModel>(() => _activityRepository.getActivity(activityId), onSuccess: (data) async {
      state = state.copyWith(activity: data);
      list();
    });
  }

  @override
  Future<void> list({num? filter, int? page, int? size, List<String>? sort}) async {
    var sort = SortBuilder()
      ..add("user.lastname", descending: false)
      ..add("user.firstname", descending: false);
    executeApiCall<PaginatedResponse<ActivityItemsModel>>(
        () => activityItemRepository.getActivityItems(activityId: state.activity!.id, page: page, size: size, sort: sort),
        onSuccess: (data) async {
      state = state.copyWith(
          activityItems: data.page.number == 0 ? data.content : [...state.activityItems, ...data.content],
          status: state.status
              .copyWith(totalElements: data.page.totalElements, totalPages: data.page.totalPages, number: data.page.number));
    });
  }

  Future<void> deleteActivityItem(num id) async {
    executeApiCall<void>(() => activityItemRepository.deleteActivityItems(id), onSuccess: (data) async {
      list();
    });
  }

  Future<void> createCreditCsv() async {
    var list = <TransactionItemModel>[];
    var users = <UserModel>[];
    for (var item in state.activityItems) {
      users.add(await _usersRepository.getUserById(item.userId));
      list.add(TransactionItemModel(
          transactionDate: state.activity!.activityDateTime,
          description: item.description,
          createUserId: item.createUserId,
          points: item.hours * 4,
          transactionType: item.transactionType,
          account: item.account,
          credit: item.transactionType == TransactionType.DUKA_MUNKA
              ? item.hours * 1000
              : item.transactionType == TransactionType.DUKA_MUNKA_2000
                  ? item.hours * 2000
                  : item.hours * 3000,
          hours: item.hours,
          userId: item.userId,
          userName: item.userName));
    }

    Utils.createCreditCsv(list, state.activity!.activityDateTime, state.activity!.description, users);
  }

  @override
  ActivityItemsState copyWithState(BaseState status) {
    return state.copyWith(status: state.status.copyWith(baseStatus: status));
  }

  Future<void> registerActivity() async {
    createCreditCsv();
    await executeApiCall(() => _activityRepository.registerActivity(state.activity!.id!, locator<UserProvider>().user!.id));
  }
}
