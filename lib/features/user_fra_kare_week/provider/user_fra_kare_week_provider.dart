import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/user_fra_kare_week/data/api/user_fra_kare_week_api.dart';
import 'package:work_hu/features/user_fra_kare_week/data/model/user_fra_kare_week_model.dart';
import 'package:work_hu/features/user_fra_kare_week/data/repository/user_fra_kare_week_repository.dart';
import 'package:work_hu/features/user_fra_kare_week/data/state/user_fra_kare_week_state.dart';

final userFraKareWeekApiProvider = Provider<UserFraKareWeekApi>((ref) => UserFraKareWeekApi());

final userFraKareWeekRepoProvider =
    Provider<UserFraKareWeekRepository>((ref) => UserFraKareWeekRepository(ref.read(userFraKareWeekApiProvider)));

final userFraKareWeekDataProvider =
    StateNotifierProvider.autoDispose<UserFraKareWeekDataNotifier, UserFraKareWeekState>((ref) =>
        UserFraKareWeekDataNotifier(ref.read(userFraKareWeekRepoProvider), ref.read(userDataProvider.notifier)));

class UserFraKareWeekDataNotifier extends StateNotifier<UserFraKareWeekState> {
  UserFraKareWeekDataNotifier(
    this.fraKareWeekRepository,
    this.currentUserProvider,
  ) : super(const UserFraKareWeekState()) {
    if (currentUserProvider.state?.role != Role.ADMIN) {
      state = state.copyWith(selectedTeamId: currentUserProvider.state!.paceTeam!.id);
    }
  }

  final UserFraKareWeekRepository fraKareWeekRepository;
  final UserDataNotifier currentUserProvider;

  Future<void> getFraKareWeeks() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await fraKareWeekRepository
          .getFraKareWeeks(weekNumber: state.weekNumber, teamId: state.selectedTeamId)
          .then((data) async {
        state = state.copyWith(streaks: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  void setUserFraKareWeeks(UserFraKareWeekModel userWeek, bool listened) {
    var streaks = state.streaks;
    var edits = {...?state.edits};
    if (edits.containsKey(userWeek.id)) {
      edits.remove(userWeek.id);
    }
    edits.addAll({userWeek.id: userWeek.copyWith(listened: listened)});

    state = state.copyWith(
        edits: edits, streaks: streaks.map((e) => e.id == userWeek.id ? e.copyWith(listened: listened) : e).toList());
  }

  Future<void> saveUserFraKareWeeks() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      for (var streak in state.edits!.values) {
        await fraKareWeekRepository.putFraKareWeek(streak.listened, streak.id);
      }
      state = state.copyWith(modelState: ModelState.success);
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  setSelectedFilter(TeamModel? team) {
    state = state.copyWith(selectedTeamId: team == null ? 0 : team.id);
    getFraKareWeeks();
  }

  setWeekNumber(num week) {
    state = state.copyWith(weekNumber: week);
    getFraKareWeeks();
  }
}
