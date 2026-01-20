import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/home/data/repository/team_round_repository.dart';
import 'package:work_hu/features/home/providers/home_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/profile/data/repository/user_round_repository.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/user_status/data/state/user_status_state.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

import '../data/api/user_status_api.dart';
import '../data/repository/user_status_repository.dart';

final userStatusApiProvider = Provider<UserStatusApi>((ref) => UserStatusApi());

final userStatusRepoProvider = Provider<UserStatusRepository>((ref) => UserStatusRepository(ref.read(userStatusApiProvider)));

final userStatusDataProvider = StateNotifierProvider.autoDispose<UserStatusDataNotifier, UserStatusState>((ref) =>
    UserStatusDataNotifier(ref.read(usersRepoProvider), ref.read(userDataProvider), ref.read(userStatusRepoProvider),
        ref.read(userRoundsRepoProvider), ref.watch(roundRepoProvider), ref.watch(teamRoundRepoProvider)));

class UserStatusDataNotifier extends StateNotifier<UserStatusState> {
  UserStatusDataNotifier(this.usersRepository, this.currentUser, this.userStatusRepoProvider, this.userRoundRepoProvider,
      this.roundRepoProvider, this.teamRoundRepoProvider)
      : super(const UserStatusState()) {
    getUsers();
  }

  final UsersRepository usersRepository;
  final UserModel? currentUser;
  final UserStatusRepository userStatusRepoProvider;
  final UserRoundRepository userRoundRepoProvider;
  final RoundRepository roundRepoProvider;
  final TeamRoundRepository teamRoundRepoProvider;

  Future<void> getUsers([TeamModel? team]) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      var queryTeam = currentUser!.role == Role.ADMIN ? team : currentUser!.paceTeam;
      // if (state.currentRound == null) {
      await getUserStatusesAndCurrentRound(queryTeam?.id);
      // }

      // var userRounds = await userRoundRepoProvider.fetchUserRounds(
      //     roundId: state.currentRound?.id, paceTeam: queryTeam?.id);
      // state = state.copyWith(
      //     userRounds: userRounds, modelState: ModelState.success);
      orderUsers();
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
    state = state.copyWith(modelState: ModelState.success);
  }

  Future<void> getUserStatusesAndCurrentRound(num? queryTeamId) async {
    var userStatuses = await userStatusRepoProvider.getUserStatuses(DateTime.now().year, queryTeamId);
    var round = await roundRepoProvider.getCurrentRounds();
    state = state.copyWith(userStatuses: userStatuses, currentRound: round, modelState: ModelState.success);
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
    var sorted = state.userStatuses.toList();
    if (state.selectedOrderType == OrderByType.NAME) {
      sorted.sort((a, b) => (a.user.getFullName()).compareTo(b.user.getFullName()));
    } else if (state.selectedOrderType == OrderByType.STATUS) {
      sorted.sort((a, b) => (a.status.compareTo(b.status)));
    }

    state = state.copyWith(userStatuses: sorted);
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

  Future<void> setUserStatus() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await userStatusRepoProvider.setUserStatus(DateTime.now().year);
      state = state.copyWith(modelState: ModelState.success);
      getUsers();
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: "Hiba lépett fel!");
    }
  }
}

enum OrderByType { NAME, STATUS, NONE }
