import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/user_rounds/data/model/user_round_head_model.dart';
import 'package:work_hu/features/user_rounds/data/repository/user_round_repository.dart';
import 'package:work_hu/features/user_rounds/providers/user_rounds_provider.dart';
import 'package:work_hu/features/user_status/data/model/user_status_filter.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/user_status/data/state/user_status_head_state.dart';

import '../data/api/user_status_api.dart';
import '../data/repository/user_status_repository.dart';

final userStatusApiProvider = Provider<UserStatusApi>((ref) => UserStatusApi());

final userStatusRepoProvider = Provider<UserStatusRepository>(
  (ref) => UserStatusRepository(ref.read(userStatusApiProvider)),
);

final userStatusDataProvider =
    StateNotifierProvider.autoDispose<UserStatusDataNotifier, PagedState<UserStatusModel, UserStatusFilter>>(
      (ref) => UserStatusDataNotifier(ref.read(userStatusRepoProvider)),
    );

final userStatusHeadProvider = StateNotifierProvider.autoDispose<UserStatusHeadNotifier, UserStatusHeadState>(
  (ref) => UserStatusHeadNotifier(ref.read(userRoundsRepoProvider)),
);

const _byName = SortOption(label: "status_filter_name", properties: ["user.lastname", "user.firstname"]);
const _byStatus = SortOption(label: "status_filter_status", properties: ["status"]);

class UserStatusDataNotifier extends PagedListNotifier<UserStatusModel, UserStatusFilter> {
  UserStatusDataNotifier(this._userStatusRepository)
    : super(
        ListQuery(
          filter: UserStatusFilter(seasonYear: DateTime.now().year),
          sort: _byName.orders(SortDir.asc),
        ),
      );

  final UserStatusRepository _userStatusRepository;

  @override
  List<SortOption> get sortOptions => const [_byName, _byStatus];

  @override
  Future<PaginatedResponse<UserStatusModel>> fetch(ListQuery<UserStatusFilter> query, int page) =>
      _userStatusRepository.getUserStatuses(query, page: page);
}

class UserStatusHeadNotifier extends BaseDataNotifier<UserStatusHeadState> {
  UserStatusHeadNotifier(this._userRoundRepository) : super(const UserStatusHeadState()) {
    getHeadData();
  }

  final UserRoundRepository _userRoundRepository;

  /// Recalculates every user's status and refreshes the head data. Returns whether it succeeded.
  Future<bool> recalculate() async {
    final result = await executeApiCall(() => _userRoundRepository.recalculate(), onSuccess: (_) => getHeadData());
    return result != null;
  }

  Future<void> getHeadData() async {
    await executeApiCall<UserRoundHeadModel>(
      () => _userRoundRepository.getHeadData(),
      onSuccess: (data) async {
        state = state.copyWith(headData: data);
      },
    );
  }

  @override
  UserStatusHeadState copyWithState(BaseState status) => state.copyWith(status: status);
}
