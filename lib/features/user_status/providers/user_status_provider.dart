import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/home/data/repository/team_round_repository.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/profile/data/repository/user_round_repository.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/user_status/data/state/user_status_state.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final userStatusDataProvider = StateNotifierProvider.autoDispose<UserStatusDataNotifier, UserStatusState>((ref) =>
    UserStatusDataNotifier(ref.read(usersRepoProvider), ref.read(userDataProvider), ref.read(goalRepoProvider),
        ref.read(userRoundsRepoProvider), ref.watch(roundRepoProvider), ref.watch(teamRepoProvider)));

class UserStatusDataNotifier extends StateNotifier<UserStatusState> {
  UserStatusDataNotifier(this.usersRepository, this.currentUser, this.goalRepoProvider, this.userRoundRepoProvider,
      this.roundRepoProvider, this.teamRoundRepoProvider)
      : super(const UserStatusState()) {
    getUsers();
  }

  final UsersRepository usersRepository;
  final UserModel? currentUser;
  final GoalRepository goalRepoProvider;
  final UserRoundRepository userRoundRepoProvider;
  final RoundRepository roundRepoProvider;
  final TeamRoundRepository teamRoundRepoProvider;

  Future<void> getUsers([TeamModel? team]) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      if (state.currentRound == null || state.goals.isEmpty) {
        await getGoalsAndCurrentRound();
      }

      var queryTeam = currentUser!.role == Role.ADMIN ? team : currentUser!.paceTeam;
      var userRounds =
          await userRoundRepoProvider.fetchUserRounds(roundId: state.currentRound?.id, paceTeam: queryTeam?.id);
      state = state.copyWith(userRounds: userRounds, modelState: ModelState.success);
      orderUsers();
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> getGoalsAndCurrentRound() async {
    var goals = await goalRepoProvider.getGoals(DateTime.now().year);
    var round = await roundRepoProvider.getCurrentRounds();
    state = state.copyWith(goals: goals, currentRound: round);
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
    var sorted = state.userRounds.toList();
    if (state.selectedOrderType == OrderByType.NAME) {
      sorted.sort((a, b) => (a.user.getFullName()).compareTo(b.user.getFullName()));
    } else if (state.selectedOrderType == OrderByType.STATUS) {
      sorted.sort((a, b) => (a.user.currentMyShareCredit / state.goals.firstWhere((g) => g.user?.id == a.user.id).goal)
          .compareTo(b.user.currentMyShareCredit / state.goals.firstWhere((g) => g.user?.id == b.user.id).goal));
    }

    state = state.copyWith(userRounds: sorted);
  }

  Future<void> recalculate() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await teamRoundRepoProvider.recalculateTeamRounds();
      state = state.copyWith(modelState: ModelState.success);
      getUsers();
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: "Hiba lépett fel!");
    }
  }
}

enum OrderByType { NAME, STATUS, NONE }
