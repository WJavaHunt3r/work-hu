import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/user_fra_kare_week/data/api/user_fra_kare_week_api.dart';
import 'package:work_hu/features/user_fra_kare_week/data/model/user_fra_kare_week_model.dart';
import 'package:work_hu/features/user_fra_kare_week/data/repository/user_fra_kare_week_repository.dart';

typedef UserFraKareWeekFilter = ({num weekNumber, num? teamId});

final userFraKareWeekApiProvider = Provider<UserFraKareWeekApi>((ref) => UserFraKareWeekApi());

final userFraKareWeekRepoProvider = Provider<UserFraKareWeekRepository>(
  (ref) => UserFraKareWeekRepository(ref.read(userFraKareWeekApiProvider)),
);

/// Who listened in one week, by week number.
final userFraKareWeekDataProvider = StateNotifierProvider.autoDispose
    .family<UserFraKareWeekDataNotifier, PagedState<UserFraKareWeekModel, UserFraKareWeekFilter>, num>(
      (ref, weekNumber) => UserFraKareWeekDataNotifier(ref.read(userFraKareWeekRepoProvider), weekNumber),
    );

class UserFraKareWeekDataNotifier extends PagedListNotifier<UserFraKareWeekModel, UserFraKareWeekFilter> {
  UserFraKareWeekDataNotifier(this.fraKareWeekRepository, num weekNumber)
    : super(ListQuery(filter: (weekNumber: weekNumber, teamId: null)));

  final UserFraKareWeekRepository fraKareWeekRepository;

  /// Checkbox changes not saved yet, by id.
  final Map<num, UserFraKareWeekModel> _edits = {};

  /// Not paged by the server: returns the whole week at once.
  @override
  Future<PaginatedResponse<UserFraKareWeekModel>> fetch(ListQuery<UserFraKareWeekFilter> query, int page) async =>
      PaginatedResponse.all(
        await fraKareWeekRepository.getFraKareWeeks(weekNumber: query.filter.weekNumber, teamId: query.filter.teamId),
      );

  void setUserFraKareWeeks(UserFraKareWeekModel userWeek, bool listened) {
    _edits[userWeek.id] = userWeek.copyWith(listened: listened);
    updateItems((items) => [for (final e in items) e.id == userWeek.id ? e.copyWith(listened: listened) : e]);
  }

  Future<void> saveUserFraKareWeeks() async {
    final edits = _edits.values.toList();
    await executeApiCall<bool>(() async {
      for (var streak in edits) {
        await fraKareWeekRepository.putFraKareWeek(streak.listened, streak.id);
      }
      return true;
    }, onSuccess: (_) async => _edits.clear());
  }

  Future<void> setSelectedFilter(TeamModel? team) =>
      setFilter((weekNumber: state.query.filter.weekNumber, teamId: team == null ? 0 : team.id));
}
