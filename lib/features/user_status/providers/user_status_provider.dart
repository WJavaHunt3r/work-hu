import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/user_status/data/state/user_status_state.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final userStatusDataProvider = StateNotifierProvider.autoDispose<UserStatusDataNotifier, UserStatusState>((ref) =>
    UserStatusDataNotifier(ref.read(usersRepoProvider), ref.read(userDataProvider), ref.read(userDataProvider.notifier),
        ref.read(goalRepoProvider)));

class UserStatusDataNotifier extends StateNotifier<UserStatusState> {
  UserStatusDataNotifier(
    this.usersRepository,
    this.currentUser,
    this.read,
    this.goalRepoProvider,
  ) : super(UserStatusState()) {
    getUsers();
  }

  final UsersRepository usersRepository;
  final UserModel? currentUser;
  final GoalRepository goalRepoProvider;
  final UserDataNotifier read;

  Future<void> getUsers([TeamModel? team]) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await usersRepository.getUsers(currentUser!.role == Role.ADMIN ? team : currentUser!.team).then((value) {
        state = state.copyWith(users: value, modelState: ModelState.success);
        orderUsers();
      });
      await goalRepoProvider.getGoals(DateTime.now().year).then((goals) => state = state.copyWith(goals: goals));
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
    } else if (state.selectedOrderType == OrderByType.STATUS) {
      sorted.sort((a, b) => (a.currentMyShareCredit / state.goals.firstWhere((g) => g.user.id == a.id).goal)
          .compareTo(b.currentMyShareCredit / state.goals.firstWhere((g) => g.user.id == b.id).goal));
    }

    state = state.copyWith(users: sorted);
  }
}

enum OrderByType { NAME, STATUS, NONE }
