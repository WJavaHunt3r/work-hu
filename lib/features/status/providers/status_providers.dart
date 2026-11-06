import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/cache/user_data_cache.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/status/data/state/status_state.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_items_filter.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/user_rounds/data/model/user_round_head_model.dart';
import 'package:work_hu/features/user_rounds/data/model/user_round_model.dart';
import 'package:work_hu/features/user_rounds/data/repository/user_round_repository.dart';
import 'package:work_hu/features/user_rounds/providers/user_rounds_provider.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/user_status/data/repository/user_status_repository.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

import '../../../app/providers/base_provider.dart';

/// Whether the Status tab has something to show: a goal (the backend's user status) this season for the user or one
/// of their children; the backend answers 404 when there is none. Only members are asked. It is asked again when the
/// user changes, when the app comes back to the front and after a refresh of Home or the Status page; meanwhile the last answer stays (`value`), so the tab
/// doesn't come and go while it loads. Other failures are errors and keep the last answer too.
final hasStatusGoalProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(userDataProvider).user;
  if (user == null || !user.isMember()) return false;
  final resume = AppLifecycleListener(onResume: ref.invalidateSelf);
  ref.onDispose(resume.dispose);
  final statuses = ref.read(userStatusRepoProvider);
  final year = DateTime.now().year;
  Future<bool> hasGoal(num userId) async {
    try {
      await statuses.getUserStatusByUserId(userId, year);
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return false;
      rethrow;
    }
  }

  if (await hasGoal(user.id)) return true;
  for (final child in await ref.read(usersRepoProvider).getChildren(user.id)) {
    if (await hasGoal(child.id)) return true;
  }
  return false;
});

final statusDataProvider = StateNotifierProvider.autoDispose<StatusDataNotifier, StatusState>(
  (ref) => StatusDataNotifier(
    ref.read(userRoundsRepoProvider),
    ref.read(userStatusRepoProvider),
    ref.read(usersRepoProvider),
    ref.read(transactionItemsRepoProvider),
    ref.read(goalRepoProvider),
  ),
);

class StatusDataNotifier extends BaseDataNotifier<StatusState> {
  StatusDataNotifier(
    this.userRoundRepoProvider,
    this.userStatusRepoProvider,
    this.usersRepository,
    this._transactionItemsRepository,
    this.goalsRepository,
  ) : super(_cached()) {
    getUserInfoAndUserRounds();
  }

  final UserRoundRepository userRoundRepoProvider;
  final UserStatusRepository userStatusRepoProvider;
  final UsersRepository usersRepository;
  final TransactionItemsRepository _transactionItemsRepository;
  final GoalRepository goalsRepository;

  /// True once there is something on screen (from the cache or loaded before): requests then run in the background,
  /// without the loading overlay and without an error dialog, and a failure keeps what is shown.
  bool _hasData = false;

  /// What the user saw last time ([UserDataCache.status]), shown until the API answers.
  static StatusState _cached() {
    return UserDataCache.instance.parse(
          locator<UserProvider>().user?.id,
          UserDataCache.status,
          (json) => StatusState(
            statuses: [for (final s in json['statuses'] as List) UserStatusModel.fromJson(s)],
            children: [for (final c in json['children'] as List) UserModel.fromJson(c)],
            userRoundHead: UserRoundHeadModel.fromJson(json['head']),
            transactions: [for (final t in json['transactions'] as List) TransactionItemModel.fromJson(t)],
          ),
        ) ??
        const StatusState();
  }

  Future<void> getUserInfoAndUserRounds() async {
    final userModel = locator<UserProvider>().user;
    if (userModel == null) return;
    _hasData = _hasData || state.statuses.isNotEmpty || state.userRoundHead != const StatusState().userRoundHead;
    final background = _hasData;

    await Future.wait([
      _loadOwnStatus(userModel, background),
      _loadChildren(userModel, background),
      executeApiCall<UserRoundHeadModel>(
        () => userRoundRepoProvider.getHeadData(),
        background: background,
        onSuccess: (head) async {
          if (!mounted) return;
          state = state.copyWith(userRoundHead: head);
          _save(userModel.id);
        },
      ),
    ]);
  }

  Future<void> _loadOwnStatus(UserModel userModel, bool background) async {
    await executeApiCall<UserStatusModel>(
      () => getUserStatus(userModel.id),
      background: background,
      onSuccess: (userRounds) async {
        if (!mounted) return;
        _putStatus(userRounds, first: true);
        _save(userModel.id);
        if (userRounds.userId == userModel.id) {
          executeApiCall<PaginatedResponse<TransactionItemModel>>(
            () => _transactionItemsRepository.getTransactionItems(
              ListQuery(
                filter: TransactionItemsFilter(userId: userModel.id, seasonYear: DateTime.now().year),
                size: 10,
                sort: const [SortOrder("transactionDate", SortDir.desc)],
              ),
            ),
            background: background,
            onSuccess: (data) async {
              if (!mounted) return;
              state = state.copyWith(transactions: data.content);
              _save(userModel.id);
            },
          );
        }
      },
      onError: (error) async {
        if (!mounted) return;
        // No status this season (e.g. no goal): a cached one must not stay
        if (error.contains("404")) {
          state = state.copyWith(statuses: state.statuses.where((s) => s.userId != userModel.id).toList());
          _save(userModel.id);
        }
        state = copyWithModelState(ModelState.empty);
      },
    );
  }

  Future<void> _loadChildren(UserModel userModel, bool background) async {
    await executeApiCall<List<UserModel>>(
      () => usersRepository.getChildren(userModel.id),
      background: background,
      onSuccess: (children) async {
        if (!mounted) return;
        // Cached statuses of people no longer in the family go
        final family = {userModel.id, for (final c in children) c.id};
        state = state.copyWith(
          children: children,
          statuses: state.statuses.where((s) => family.contains(s.userId)).toList(),
        );
        for (var child in children) {
          try {
            final status = await getUserStatus(child.id);
            if (!mounted) return;
            _putStatus(status);
          } catch (_) {
            // Keeps the child's cached status, if any
          }
        }
        _save(userModel.id);
      },
      onError: (error) async {
        if (mounted) state = copyWithModelState(ModelState.empty);
      },
    );
  }

  /// Replaces the status of the same user, else adds it: the user's own first, their children after.
  void _putStatus(UserStatusModel status, {bool first = false}) {
    final statuses = [...state.statuses];
    final index = statuses.indexWhere((s) => s.userId == status.userId);
    if (index >= 0) {
      statuses[index] = status;
    } else if (first) {
      statuses.insert(0, status);
    } else {
      statuses.add(status);
    }
    state = state.copyWith(statuses: statuses);
    _hasData = true;
  }

  void _save(num userId) {
    UserDataCache.instance.write(userId, UserDataCache.status, {
      'statuses': state.statuses,
      'children': state.children,
      'head': state.userRoundHead,
      'transactions': state.transactions,
    });
  }

  Future<List<UserRoundModel>> getUserRounds(num id) async {
    return userRoundRepoProvider.fetchUserRounds(userId: id, seasonYear: DateTime.now().year);
  }

  Future<UserStatusModel> getUserStatus(num id) async {
    return await userStatusRepoProvider.getUserStatusByUserId(id, DateTime.now().year);
  }

  @override
  StatusState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }
}
