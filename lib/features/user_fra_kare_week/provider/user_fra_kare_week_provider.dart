import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/user_fra_kare_week/data/api/user_fra_kare_week_api.dart';
import 'package:work_hu/features/user_fra_kare_week/data/model/user_fra_kare_week_model.dart';
import 'package:work_hu/features/user_fra_kare_week/data/repository/user_fra_kare_week_repository.dart';
import 'package:work_hu/features/user_fra_kare_week/data/state/user_fra_kare_week_state.dart';

final userFraKareWeekApiProvider = Provider<UserFraKareWeekApi>((ref) => UserFraKareWeekApi());

final userFraKareWeekRepoProvider = Provider<UserFraKareWeekRepository>(
  (ref) => UserFraKareWeekRepository(ref.read(userFraKareWeekApiProvider)),
);

final userFraKareWeekDataProvider =
    StateNotifierProvider.autoDispose<UserFraKareWeekDataNotifier, UserFraKareWeekState>(
      (ref) => UserFraKareWeekDataNotifier(ref.read(userFraKareWeekRepoProvider)),
    );

class UserFraKareWeekDataNotifier extends BaseDataNotifier<UserFraKareWeekState> implements ListApiProvider {
  UserFraKareWeekDataNotifier(this.fraKareWeekRepository) : super(const UserFraKareWeekState());

  final UserFraKareWeekRepository fraKareWeekRepository;

  @override
  Future<void> list({filter, int? page, int? size, List<String>? sort}) async {
    await executeApiCall<List<UserFraKareWeekModel>>(
      () => fraKareWeekRepository.getFraKareWeeks(weekNumber: state.weekNumber, teamId: state.selectedTeamId),
      background: true,
      onSuccess: (streaks) async {
        state = state.copyWith(
          streaks: streaks,
          listState: state.listState.copyWith(number: 0, totalPages: 1, totalElements: streaks.length),
        );
      },
    );
  }

  void setUserFraKareWeeks(UserFraKareWeekModel userWeek, bool listened) {
    var streaks = state.streaks;
    var edits = {...?state.edits};
    if (edits.containsKey(userWeek.id)) {
      edits.remove(userWeek.id);
    }
    edits.addAll({userWeek.id: userWeek.copyWith(listened: listened)});

    state = state.copyWith(
      edits: edits,
      streaks: streaks.map((e) => e.id == userWeek.id ? e.copyWith(listened: listened) : e).toList(),
    );
  }

  Future<void> saveUserFraKareWeeks() async {
    var edits = state.edits?.values.toList() ?? [];
    await executeApiCall<bool>(() async {
      for (var streak in edits) {
        await fraKareWeekRepository.putFraKareWeek(streak.listened, streak.id);
      }
      return true;
    });
  }

  setSelectedFilter(TeamModel? team) {
    state = state.copyWith(selectedTeamId: team == null ? 0 : team.id);
    list();
  }

  setWeekNumber(num week) {
    state = state.copyWith(weekNumber: week);
    list();
  }

  @override
  UserFraKareWeekState copyWithState(BaseState status) {
    return state.copyWith(listState: state.listState.copyWith(baseStatus: status));
  }
}
