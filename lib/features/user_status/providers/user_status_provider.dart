import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/user_status/data/state/user_status_state.dart';

import '../data/api/user_status_api.dart';
import '../data/repository/user_status_repository.dart';

final userStatusApiProvider = Provider<UserStatusApi>((ref) => UserStatusApi());

final userStatusRepoProvider = Provider<UserStatusRepository>((ref) => UserStatusRepository(ref.read(userStatusApiProvider)));

final userStatusDataProvider =
    StateNotifierProvider.autoDispose<UserStatusDataNotifier, UserStatusState>((ref) => UserStatusDataNotifier(
          ref.read(userDataProvider).user,
          ref.read(userStatusRepoProvider),
        ));

class UserStatusDataNotifier extends BaseDataNotifier<UserStatusState> implements ListApiProvider<TeamModel> {
  UserStatusDataNotifier(this.currentUser, this.userStatusRepoProvider) : super(const UserStatusState()) {
    list();
  }

  final UserModel? currentUser;
  final UserStatusRepository userStatusRepoProvider;

  @override
  Future<void> list({TeamModel? filter, int? page, int? size, String? sort}) async {
    var sort = SortBuilder()
      ..add("user.lastname", descending: false)
      ..add("user.firstname", descending: false);
    await executeApiCall<PaginatedResponse<UserStatusModel>>(
        () => userStatusRepoProvider.getUserStatuses(DateTime.now().year, null,
            page: page ?? state.status.number, size: size ?? state.status.size, sort: sort), onSuccess: (data) async {
      state = state.copyWith(
          userStatuses: [...state.userStatuses, ...data.content],
          status: state.status
              .copyWith(totalElements: data.page.totalElements, number: data.page.number, totalPages: data.page.totalPages));
    });
  }

  setSelectedFilter(TeamModel? team) {
    state = state.copyWith(selectedTeamId: team == null ? 0 : team.id);
    list(filter: team);
  }

  setSelectedOrderType(OrderByType orderByType) {
    state = state.copyWith(selectedOrderType: orderByType);
  }

  Future<void> recalculate() async {
    list();
  }

  Future<void> setUserStatus() async {
    executeApiCall(() => userStatusRepoProvider.setUserStatus(DateTime.now().year), onSuccess: (data) async => list());
  }

  @override
  UserStatusState copyWithState(BaseState status) {
    return state.copyWith(status: state.status.copyWith(baseStatus: status));
  }
}

enum OrderByType { NAME, STATUS, NONE }
