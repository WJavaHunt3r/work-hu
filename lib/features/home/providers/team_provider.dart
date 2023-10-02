import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/home/data/api/team_api.dart';
import 'package:work_hu/features/home/data/repository/teams_repository.dart';
import 'package:work_hu/features/home/data/state/team_state.dart';
import 'package:work_hu/features/login/data/state/login_state.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/utils.dart';

final teamApiProvider = Provider<TeamApi>((ref) => TeamApi());

final teamRepoProvider = Provider<TeamRepository>((ref) => TeamRepository(ref.read(teamApiProvider)));

final teamDataProvider = StateNotifierProvider.autoDispose<TeamDataNotifier, TeamState>(
    (ref) => TeamDataNotifier(ref.read(teamRepoProvider), ref.read(loginDataProvider.notifier)));

class TeamDataNotifier extends StateNotifier<TeamState> {
  TeamDataNotifier(this.teamRepository, this.read, ) : super(const TeamState()) {
    checkLoginCredentials();
  }

  final TeamRepository teamRepository;
  final LoginDataNotifier read;

  Future<void> getTeams() async {
    state = state.copyWith(isLoading: true);
    try {
      await teamRepository.fetchTeams().then((data) {
        state = state.copyWith(teams: data, isLoading: false, isError:false);
      });
    } catch (e) {
      state = state.copyWith(isLoading: false, isError: true);
    }
  }

  Future<void> checkLoginCredentials() async {
    var username = await Utils.getData('username');
    var password = await Utils.getData('password');

    if(username.isNotEmpty && password.isNotEmpty){
      state = state.copyWith(isLoading: true);
      read.state = LoginState(username: username, password: password);
      await read.login();
      state = state.copyWith(isLoading: false, isError: read.state.modelState == ModelState.error);
    }
    getTeams();
  }
}
