import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/user_status/data/state/user_status_state.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final userStatusDataProvider = StateNotifierProvider.autoDispose<UserStatusDataNotifier, UserStatusState>(
    (ref) => UserStatusDataNotifier(ref.read(usersRepoProvider), ref.read(userDataProvider)));

class UserStatusDataNotifier extends StateNotifier<UserStatusState> {
  UserStatusDataNotifier(this.usersRepository, this.currentUser) : super(UserStatusState()) {
    getUsers();
  }

  final UsersRepository usersRepository;
  final UserModel? currentUser;

  Future<void> getUsers([TeamModel? team]) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await usersRepository.getUsers(currentUser!.role == Role.ADMIN ? team : currentUser!.team).then((value) {
        state = state.copyWith(users: value, modelState: ModelState.success);
        orderUsers();
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  setSelectedFilter(TeamModel? team) {
    state = state.copyWith(selectedTeamId: team == null ? 0 : team.id);
    getUsers(team);
  }

  setSelectedOrderType(OrderByType orderByType) {
    state = state.copyWith(selectedOrderType: orderByType);
    orderUsers();
  }

  orderUsers() {
    var sorted = state.users.toList();
    if (state.selectedOrderType == OrderByType.NAME) {
      sorted.sort((a, b) => ("${a.lastname} ${a.firstname}").compareTo("${b.lastname} ${b.firstname}"));
    } else if(state.selectedOrderType == OrderByType.STATUS){
      sorted.sort((a, b) => (a.currentMyShareCredit / a.goal).compareTo(b.currentMyShareCredit / b.goal));
    }

    state = state.copyWith(users: sorted);
  }
}

enum OrderByType { NAME, STATUS, NONE }
