import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/home/data/api/team_round_api.dart';
import 'package:work_hu/features/home/data/repository/team_round_repository.dart';
import 'package:work_hu/features/home/data/state/team_round_state.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/profile/data/repository/user_round_repository.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/teams/data/repository/teams_repository.dart';
import 'package:work_hu/features/teams/provider/teams_provider.dart';

final teamApiProvider = Provider<TeamRoundApi>((ref) => TeamRoundApi());

final teamRepoProvider = Provider<TeamRoundRepository>((ref) => TeamRoundRepository(ref.read(teamApiProvider)));

final teamRoundDataProvider = StateNotifierProvider.autoDispose<TeamRoundDataNotifier, TeamRoundState>((ref) =>
    TeamRoundDataNotifier(ref.read(teamsRepoProvider), ref.read(loginDataProvider.notifier), ref.read(loginRepoProvider),
        ref.read(userDataProvider.notifier), ref.read(userRoundsRepoProvider)));

class TeamRoundDataNotifier extends StateNotifier<TeamRoundState> {
  TeamRoundDataNotifier(
    this.teamRepository,
    this.read,
    this.loginRepository,
    this.userSessionProvider,
    this.userRoundRepository,
  ) : super(const TeamRoundState()) {
    checkLoginCredentials();
  }

  final TeamRepository teamRepository;
  final LoginDataNotifier read;
  final LoginRepository loginRepository;
  final UserDataNotifier userSessionProvider;
  final UserRoundRepository userRoundRepository;

  Future<void> getTeamRounds() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await teamRepository.fetchTeams().then((data) async {
        // data.sort((prev, next) => next.teamPoints.compareTo(prev.teamPoints));
        state = state.copyWith(
            teams: data,
            modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> checkLoginCredentials() async {
    await getTeamRounds();
    // state = state.copyWith(modelState: ModelState.processing);
    // var username = await Utils.getData('user');
    // var password = await Utils.getData('password');
    //
    // var user = userSessionProvider.state;
    // if (username.isNotEmpty && password.isNotEmpty && user == null) {
    //   //state = state.copyWith(modelState: ModelState.processing);
    //   read.state = LoginState(username: username, password: password);
    //   // await read.login();
    //   state = state.copyWith(message: read.state.message, modelState: ModelState.success);
    // } else {
    //   if (user == null && username.isNotEmpty) {
    //     await loginRepository.getUser(username).then((value) => userSessionProvider.setUser(value));
    //   }
    //   state = state.copyWith(modelState: ModelState.success);
    // }
  }
}
