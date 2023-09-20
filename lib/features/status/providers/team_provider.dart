import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/features/status/data/api/team_api.dart';
import 'package:work_hu/features/status/data/repository/teams_repository.dart';
import 'package:work_hu/features/status/data/state/team_state.dart';

final teamApiProvider = Provider<TeamApi>((ref) => TeamApi());

final teamRepoProvider = Provider<TeamRepository>((ref) => TeamRepository(ref.read(teamApiProvider)));

final teamDataProvider = StateNotifierProvider.autoDispose<TeamDataNotifier, TeamState>(
    (ref) => TeamDataNotifier(ref.read(teamRepoProvider)));

class TeamDataNotifier extends StateNotifier<TeamState> {
  TeamDataNotifier(this.teamRepository) : super(const TeamState()) {
    getTeams();
  }

  final TeamRepository teamRepository;

  Future<void> getTeams() async {
    state = state.copyWith(isLoading: true);
    await teamRepository.fetchTeams().then((data) {
      state = state.copyWith(teams: data, isLoading: false);
    });
  }
}
