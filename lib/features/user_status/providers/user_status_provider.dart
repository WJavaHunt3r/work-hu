import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/widgets/base_sort_widget.dart';
import 'package:work_hu/features/user_rounds/data/repository/user_round_repository.dart';
import 'package:work_hu/features/user_rounds/providers/user_rounds_provider.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/user_status/data/state/user_status_state.dart';

import '../data/api/user_status_api.dart';
import '../data/repository/user_status_repository.dart';

final userStatusApiProvider = Provider<UserStatusApi>((ref) => UserStatusApi());

final userStatusRepoProvider = Provider<UserStatusRepository>((ref) => UserStatusRepository(ref.read(userStatusApiProvider)));

final userStatusDataProvider = StateNotifierProvider.autoDispose<UserStatusDataNotifier, UserStatusState>(
    (ref) => UserStatusDataNotifier(ref.read(userStatusRepoProvider), ref.read(userRoundsRepoProvider)));

class UserStatusDataNotifier extends BaseDataNotifier<UserStatusState> implements ListApiProvider<dynamic> {
  UserStatusDataNotifier(this._userStatusRepoProvider, this._userRoundRepository) : super(const UserStatusState()) {
    state = state.copyWith(
        status: state.status.copyWith(sortParameters: [
      SortItem(label: "status_filter_name", values: ["user.lastname", "user.firstname"], descending: false),
      SortItem(label: "status_filter_name", values: ["user.lastname", "user.firstname"], descending: true),
      SortItem(label: "status_filter_status", values: ["status"], descending: false),
      SortItem(label: "status_filter_status", values: ["status"], descending: true)
    ]));
    // list();
  }

  final UserStatusRepository _userStatusRepoProvider;
  final UserRoundRepository _userRoundRepository;

  @override
  Future<void> list({dynamic filter, int? page, int? size, List<String>? sort}) async {
    await executeApiCall<PaginatedResponse<UserStatusModel>>(
        () => _userStatusRepoProvider.getUserStatuses(DateTime.now().year, null,
            page: page ?? state.status.number,
            size: size ?? state.status.size,
            sort: sort ?? state.status.sort), onSuccess: (data) async {
      state = state.copyWith(
          userStatuses: page == 0 ? data.content : [...state.userStatuses, ...data.content],
          status: state.status.copyWith(
              totalElements: data.page.totalElements,
              number: data.page.number,
              totalPages: data.page.totalPages,
              sort: sort ?? state.status.sort));
    });
  }

  Future<void> recalculate() async {
    executeApiCall(() => _userRoundRepository.recalculate(), onSuccess: (data) => list());
  }

  Future<void> setUserStatus() async {
    executeApiCall(() => _userStatusRepoProvider.setUserStatus(DateTime.now().year), onSuccess: (data) async => list());
  }

  @override
  UserStatusState copyWithState(BaseState status) {
    return state.copyWith(status: state.status.copyWith(baseStatus: status));
  }
}
