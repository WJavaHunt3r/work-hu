import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/data/repository/activity_repository.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/activity_items/data/api/activity_items_api.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_filter.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/activity_items/data/repository/activity_items_repository.dart';
import 'package:work_hu/features/activity_items/data/state/activity_detail_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/providers/base_provider.dart';

final activityItemsApiProvider = Provider<ActivityItemsApi>((ref) => ActivityItemsApi());

final activityItemsRepoProvider = Provider<ActivityItemsRepository>(
  (ref) => ActivityItemsRepository(ref.read(activityItemsApiProvider)),
);

/// The registrations of one activity, by activity id.
final activityItemsDataProvider = StateNotifierProvider.autoDispose
    .family<ActivityItemsDataNotifier, PagedState<ActivityItemsModel, ActivityItemsFilter>, num>(
      (ref, activityId) => ActivityItemsDataNotifier(ref.read(activityItemsRepoProvider), activityId),
    );

/// The activity whose registrations are listed, by activity id.
final activityDetailProvider = StateNotifierProvider.autoDispose
    .family<ActivityDetailNotifier, ActivityDetailState, num>(
      (ref, activityId) => ActivityDetailNotifier(
        ref.read(activityRepoProvider),
        ref.read(usersRepoProvider),
        ref.read(userDataProvider).user,
        activityId,
      ),
    );

class ActivityItemsDataNotifier extends PagedListNotifier<ActivityItemsModel, ActivityItemsFilter> {
  ActivityItemsDataNotifier(this.activityItemRepository, num activityId)
    : super(
        ListQuery(
          filter: ActivityItemsFilter(activityId: activityId),
          sort: const [SortOrder("user.lastname"), SortOrder("user.firstname")],
        ),
      );

  final ActivityItemsRepository activityItemRepository;

  @override
  Future<PaginatedResponse<ActivityItemsModel>> fetch(ListQuery<ActivityItemsFilter> query, int page) =>
      activityItemRepository.getActivityItems(query, page: page);

  Future<void> deleteActivityItem(num id) async {
    await executeApiCall<void>(
      () => activityItemRepository.deleteActivityItems(id),
      onSuccess: (_) async => removeItems((item) => item.id == id),
    );
  }
}

class ActivityDetailNotifier extends BaseDataNotifier<ActivityDetailState> {
  ActivityDetailNotifier(this._activityRepository, this._usersRepository, this.currentUser, num activityId)
    : super(const ActivityDetailState()) {
    getActivity(activityId);
  }

  final ActivityRepository _activityRepository;
  final UsersRepository _usersRepository;
  final UserModel? currentUser;

  Future<void> getActivity(num activityId) async {
    await executeApiCall<ActivityModel>(
      () => _activityRepository.getActivity(activityId),
      onSuccess: (data) async {
        state = state.copyWith(activity: data);
      },
    );
  }

  /// Exports [items] (the registrations loaded so far) as a MyShare credit CSV.
  Future<void> createCreditCsv(List<ActivityItemsModel> items) async {
    final activity = state.activity!;
    var list = <TransactionItemModel>[];
    var users = <UserModel>[];
    for (var item in items) {
      users.add(await _usersRepository.getUserById(item.userId));
      list.add(
        TransactionItemModel(
          transactionDate: activity.activityDateTime,
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
          userName: item.userName,
        ),
      );
    }

    Utils.createCreditCsv(list, activity.activityDateTime, activity.description, users);
  }

  Future<void> registerActivity(List<ActivityItemsModel> items) async {
    createCreditCsv(items);
    await executeApiCall(() => _activityRepository.registerActivity(state.activity!.id!, currentUser!.id));
  }

  @override
  ActivityDetailState copyWithState(BaseState status) => state.copyWith(status: status);
}
