import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/home/data/api/team_round_api.dart';
import 'package:work_hu/features/home/data/repository/team_round_repository.dart';
import 'package:work_hu/features/home/data/state/team_round_state.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/data/state/login_state.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/profile/data/repository/user_round_repository.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/utils.dart';

final teamApiProvider = Provider<TeamRoundApi>((ref) => TeamRoundApi());

final teamRepoProvider = Provider<TeamRoundRepository>((ref) => TeamRoundRepository(ref.read(teamApiProvider)));

final teamRoundDataProvider = StateNotifierProvider.autoDispose<TeamRoundDataNotifier, TeamRoundState>((ref) =>
    TeamRoundDataNotifier(ref.read(teamRepoProvider), ref.read(loginDataProvider.notifier), ref.read(loginRepoProvider),
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

  final TeamRoundRepository teamRepository;
  final LoginDataNotifier read;
  final LoginRepository loginRepository;
  final UserDataNotifier userSessionProvider;
  final UserRoundRepository userRoundRepository;

  Future<void> getTeamRounds() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await teamRepository.fetchTeamRounds().then((data) async {
        data.sort((a, b) => a.round.roundNumber.compareTo(b.round.roundNumber));
        data.sort((prev, next) => next.teamPoints.compareTo(prev.teamPoints));
        state = state.copyWith(teams: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> checkLoginCredentials() async {
    var username = await Utils.getData('user');
    var password = await Utils.getData('password');

    var user = userSessionProvider.state;
    if (username.isNotEmpty && password.isNotEmpty && user == null) {
      state = state.copyWith(modelState: ModelState.processing);
      read.state = LoginState(username: username, password: password);
      await read.login();
      state = state.copyWith(modelState: read.state.modelState);
    } else {
      if (user == null && username.isNotEmpty) {
        await loginRepository.getUser(username).then((value) => userSessionProvider.setUser(value));
      }
    }
    await getTeamRounds();
  }
}
