import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/goal/data/api/goal_api.dart';
import 'package:work_hu/features/goal/data/model/goal_filter.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/data/state/goal_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/season/data/repository/season_repository.dart';
import 'package:work_hu/features/season/provider/season_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/providers/base_provider.dart';

final goalApiProvider = Provider<GoalApi>((ref) => GoalApi());

final goalRepoProvider = Provider<GoalRepository>((ref) => GoalRepository(ref.read(goalApiProvider)));

final goalDataProvider = StateNotifierProvider.autoDispose<GoalDataNotifier, GoalState>((ref) => GoalDataNotifier(
    ref.read(goalRepoProvider), ref.read(usersRepoProvider), ref.read(seasonRepoProvider), ref.read(userDataProvider).user));

class GoalDataNotifier extends BaseDataNotifier<GoalState> implements ListApiProvider<GoalFilter> {
  GoalDataNotifier(
    this.goalRepository,
    this.usersRepository,
    this.seasonRepository,
    this.currentUserProvider,
  ) : super(GoalState(
            filter: GoalFilter(seasonYear: DateTime.now().year),
            listState: BaseListState(
                sort: (SortBuilder()
                      ..add("user.lastname", descending: false)
                      ..add("user.firstname", descending: false))
                    .build()))) {
    list();
  }

  final GoalRepository goalRepository;
  final UsersRepository usersRepository;
  final SeasonRepository seasonRepository;
  final UserModel? currentUserProvider;

  @override
  Future<void> list({GoalFilter? filter, int? page, int? size, List<String>? sort}) async {
    executeApiCall<PaginatedResponse<GoalModel>>(
        () => goalRepository.getGoals(
            filter: filter ?? state.filter,
            pageStru: PageStru(
                page: page ?? state.listState.number,
                size: size ?? state.listState.size,
                sort: sort ?? state.listState.sort)), onSuccess: (data) async {
      state = state.copyWith(
          goals: page == 0 ? data.content : [...state.goals, ...data.content],
          listState: state.listState
              .copyWith(totalElements: data.page.totalElements, totalPages: data.page.totalPages, number: data.page.number));
    });
  }

  Future<void> uploadGoalsCsv() async {
    final pickedFile = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

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
            if (!state.goals.any((element) => element.userId == user.id)) {
              var goal = row[6];
              if (goal != 0) {
                GoalModel goalModel = GoalModel(
                    goal: goal,
                    userId: user.id,
                    seasonYear: seasons.firstWhere((s) => s.seasonYear == DateTime.now().year).seasonYear);
                goals.add(goalModel);
              }
            }
          } catch (e) {}
        }
        rowNb++;
      }
      for (var goal in goals) {
        await goalRepository.postGoal(goal);
      }
    }
  }

  Future<void> deleteGoal(num goalId) async {
    List<GoalModel> origItems = state.goals;
    List<GoalModel> items = [...origItems];
    items.removeWhere((a) => a.id != goalId);
    executeApiCall(() => goalRepository.deleteGoal(goalId, currentUserProvider!.id), onSuccess: (data) async {
      state = state.copyWith(goals: items);
    }, onError: (error) async {
      state = state.copyWith(goals: origItems);
    });
  }

  Future<void> updateGoal(GoalModel goal) async {
    state = state.copyWith(selectedGoal: goal);
  }

  Future<void> saveGoal() async {
    var mode = state.mode;
    var goal = state.selectedGoal;
    if (goal.seasonYear != null && goal.userId != null && goal.goal != 0) {
      if (mode == MaintenanceMode.create) {
        await goalRepository.postGoal(state.selectedGoal);
      } else if (mode == MaintenanceMode.edit) {
        await goalRepository.putGoal(state.selectedGoal, currentUserProvider!.id);
      }
      state = state.copyWith(selectedGoal: const GoalModel(goal: 0));
    }
  }

  Future<void> presetGoal(GoalModel goal, MaintenanceMode mode) async {
     if (goal.seasonYear == null) {
      await seasonRepository.getSeasons().then(
          (value) => goal = goal.copyWith(seasonYear: value.firstWhere((s) => s.seasonYear == DateTime.now().year).seasonYear));
    } else {}
    state = state.copyWith(selectedGoal: goal, mode: mode);
  }

  @override
  GoalState copyWithState(BaseState status) {
    return state.copyWith(listState: state.listState.copyWith(baseStatus: status));
  }
}
