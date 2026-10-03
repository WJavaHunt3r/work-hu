import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/goal/data/api/goal_api.dart';
import 'package:work_hu/features/goal/data/model/goal_filter.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/data/state/goal_maintenance_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/season/data/repository/season_repository.dart';
import 'package:work_hu/features/season/provider/season_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final goalApiProvider = Provider<GoalApi>((ref) => GoalApi());

final goalRepoProvider = Provider<GoalRepository>((ref) => GoalRepository(ref.read(goalApiProvider)));

final goalDataProvider = StateNotifierProvider.autoDispose<GoalDataNotifier, PagedState<GoalModel, GoalFilter>>(
  (ref) => GoalDataNotifier(
    ref.read(goalRepoProvider),
    ref.read(usersRepoProvider),
    ref.read(seasonRepoProvider),
    ref.read(userDataProvider).user,
  ),
);

final goalMaintenanceProvider = StateNotifierProvider.autoDispose<GoalMaintenanceNotifier, GoalMaintenanceState>(
  (ref) => GoalMaintenanceNotifier(
    ref.read(goalRepoProvider),
    ref.read(seasonRepoProvider),
    ref.read(userDataProvider).user,
  ),
);

class GoalDataNotifier extends PagedListNotifier<GoalModel, GoalFilter> {
  GoalDataNotifier(this.goalRepository, this.usersRepository, this.seasonRepository, this.currentUser)
    : super(
        ListQuery(
          filter: GoalFilter(seasonYear: DateTime.now().year),
          sort: const [SortOrder("user.lastname"), SortOrder("user.firstname")],
        ),
      );

  final GoalRepository goalRepository;
  final UsersRepository usersRepository;
  final SeasonRepository seasonRepository;
  final UserModel? currentUser;

  @override
  Future<PaginatedResponse<GoalModel>> fetch(ListQuery<GoalFilter> query, int page) =>
      goalRepository.getGoals(query, page: page);

  Future<void> uploadGoalsCsv() async {
    final pickedFile = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

    if (pickedFile.isNotEmpty) {
      var file = pickedFile.first;

      final input = utf8.decode(await file.readAsBytes());
      final fields = Csv(autoDetect: false, dynamicTyping: true).decode(input);
      var seasons = await seasonRepository.getSeasons();
      var goals = [];
      var rowNb = 0;
      for (var row in fields) {
        if (rowNb != 0) {
          try {
            var user = await usersRepository.getUserByMyShareId(row[0]);
            if (!state.items.any((element) => element.userId == user.id)) {
              var goal = row[6];
              if (goal != 0) {
                GoalModel goalModel = GoalModel(
                  goal: goal,
                  userId: user.id,
                  seasonYear: seasons.firstWhere((s) => s.seasonYear == DateTime.now().year).seasonYear,
                );
                goals.add(goalModel);
              }
            }
          } catch (_) {
            // Skip rows that can't be parsed.
          }
        }
        rowNb++;
      }
      for (var goal in goals) {
        await goalRepository.postGoal(goal);
      }
    }
  }

  Future<void> deleteGoal(num goalId) async {
    await executeApiCall(
      () => goalRepository.deleteGoal(goalId, currentUser!.id),
      onSuccess: (_) async => removeItems((goal) => goal.id == goalId),
    );
  }
}

/// The goal being created or edited in the maintenance dialog.
class GoalMaintenanceNotifier extends StateNotifier<GoalMaintenanceState> {
  GoalMaintenanceNotifier(this.goalRepository, this.seasonRepository, this.currentUser)
    : super(const GoalMaintenanceState());

  final GoalRepository goalRepository;
  final SeasonRepository seasonRepository;
  final UserModel? currentUser;

  Future<void> updateGoal(GoalModel goal) async {
    state = state.copyWith(selectedGoal: goal);
  }

  Future<void> saveGoal() async {
    var mode = state.mode;
    var goal = state.selectedGoal;
    if (goal.seasonYear != null && goal.userId != null && goal.goal != 0) {
      if (mode == MaintenanceMode.create) {
        await goalRepository.postGoal(goal);
      } else if (mode == MaintenanceMode.edit) {
        await goalRepository.putGoal(goal, currentUser!.id);
      }
      state = state.copyWith(selectedGoal: const GoalModel(goal: 0));
    }
  }

  Future<void> presetGoal(GoalModel goal, MaintenanceMode mode) async {
    if (goal.seasonYear == null) {
      final seasons = await seasonRepository.getSeasons();
      goal = goal.copyWith(seasonYear: seasons.firstWhere((s) => s.seasonYear == DateTime.now().year).seasonYear);
    }
    state = state.copyWith(selectedGoal: goal, mode: mode);
  }
}
