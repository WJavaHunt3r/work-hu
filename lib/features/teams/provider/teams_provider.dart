import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/teams/data/api/team_api.dart';
import 'package:work_hu/features/teams/data/repository/teams_repository.dart';
import 'package:work_hu/features/teams/data/state/team_state.dart';

final teamsApiProvider = Provider<TeamApi>((ref) => TeamApi());

final teamsRepoProvider = Provider<TeamRepository>((ref) => TeamRepository(ref.read(teamsApiProvider)));

final teamsDataProvider =
    StateNotifierProvider<TeamDataNotifier, TeamState>((ref) => TeamDataNotifier(ref.read(teamsRepoProvider)));

class TeamDataNotifier extends StateNotifier<TeamState> {
  TeamDataNotifier(
    this.teamsRepository,
  ) : super(const TeamState()) {
    getTeams();
  }

  final TeamRepository teamsRepository;

  Future<void> getTeams() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await teamsRepository
          .fetchTeams()
          .then((value) => state = state.copyWith(teams: value, modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }
}
