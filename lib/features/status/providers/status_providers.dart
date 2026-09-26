import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/goal/data/model/goal_filter.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/round_filter_chip/providers/round_filter_chip_provider.dart';
import 'package:work_hu/features/rounds/data/state/rounds_state.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/status/data/state/status_state.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_items_filter.dart';
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

final statusDataProvider = StateNotifierProvider.autoDispose<StatusDataNotifier, StatusState>((ref) => StatusDataNotifier(
    ref.read(userRoundsRepoProvider),
    ref.read(userStatusRepoProvider),
    ref.read(usersRepoProvider),
    ref.read(transactionItemsRepoProvider),
    ref.read(goalRepoProvider)));

class StatusDataNotifier extends BaseDataNotifier<StatusState> {
  StatusDataNotifier(this.userRoundRepoProvider, this.userStatusRepoProvider, this.usersRepository,
      this._transactionItemsRepository, this.goalsRepository)
      : super(const StatusState()) {
    getUserInfoAndUserRounds();
  }

  final UserRoundRepository userRoundRepoProvider;
  final UserStatusRepository userStatusRepoProvider;
  final UsersRepository usersRepository;
  final TransactionItemsRepository _transactionItemsRepository;
  final GoalRepository goalsRepository;

  Future<void> getUserInfoAndUserRounds() async {
    var userModel = locator<UserProvider>().user!;

    await executeApiCall<UserStatusModel>(() => getUserStatus(userModel.id), onSuccess: (userRounds) async {
      state = state.copyWith(statuses: [userRounds]);
      if (userRounds.userId == userModel.id) {
        executeApiCall<PaginatedResponse<TransactionItemModel>>(
            () => _transactionItemsRepository.getTransactionItems(
                filter: TransactionItemsFilter(userId: userModel.id, seasonYear: DateTime.now().year),
                page: 0,
                size: 10,
                sort: ["transactionDate,desc"]), onSuccess: (data) async {
          state = state.copyWith(transactions: data.content);
        });
      }
    }, onError: (error) async {
      state = copyWithModelState(ModelState.empty);
    });

    executeApiCall<List<UserModel>>(() => usersRepository.getChildren(userModel.id), onSuccess: (children) async {
      state = state.copyWith(children: children);
      for (var child in children) {
        await getUserStatus(child.id).then((status) async {
          state = state.copyWith(statuses: [...state.statuses, status]);
        }, onError: (error) async {
          state = copyWithModelState(ModelState.empty);
        });
      }
    }, onError: (error) async {
      state = copyWithModelState(ModelState.empty);
    });

    executeApiCall<UserRoundHeadModel>(() => userRoundRepoProvider.getHeadData(), onSuccess: (head) async {
      state = state.copyWith(userRoundHead:  head);
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
