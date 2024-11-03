import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/goal/data/api/goal_api.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/data/state/goal_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/season/data/repository/season_repository.dart';
import 'package:work_hu/features/season/provider/season_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

final goalApiProvider = Provider<GoalApi>((ref) => GoalApi());

final goalRepoProvider = Provider<GoalRepository>((ref) => GoalRepository(ref.read(goalApiProvider)));

final goalDataProvider = StateNotifierProvider<GoalDataNotifier, GoalState>((ref) => GoalDataNotifier(
    ref.read(goalRepoProvider),
    ref.read(usersRepoProvider),
    ref.read(seasonRepoProvider),
    ref.read(userDataProvider.notifier)));

class GoalDataNotifier extends StateNotifier<GoalState> {
  GoalDataNotifier(
    this.goalRepository,
    this.usersRepository,
    this.seasonRepository,
    this.currentUserProvider,
  ) : super(const GoalState()) {
    getGoals(DateTime.now().year);

    userController = TextEditingController(text: "");
  }

  final GoalRepository goalRepository;
  final UsersRepository usersRepository;
  final SeasonRepository seasonRepository;
  final UserDataNotifier currentUserProvider;
  late final TextEditingController userController;

  Future<void> getGoals(num? seasonYear) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await goalRepository.getGoals(seasonYear ?? DateTime.now().year).then((data) async {
        data.sort((a, b) => (a.user!.getFullName()).compareTo(b.user!.getFullName()));
        state = state.copyWith(goals: data, filtered: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<GoalModel?> getUserSeasonGoal(num userId, num seasonYear) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      return await goalRepository.getGoalByUserAndSeason(userId, seasonYear);
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
      return null;
    }
  }

  Future<void> uploadGoalsCsv() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        withData: true,
      );

      if (pickedFile != null) {
        var file = pickedFile.files.first;

        final input = utf8.decode(file.bytes!);
        final fields = const CsvToListConverter().convert(input);
        var seasons = await seasonRepository.getSeasons();
        var rowNb = 0;
        for (var row in fields) {
          if (rowNb != 0) {
            var field = row[0].split(";");
            var user = await usersRepository.getUserByMyShareId(num.tryParse(field[0]) ?? 0);
            if (!state.goals.any((element) => element.user!.id == user.id)) {
              var goal = num.tryParse(field[6]) ?? 0;
              var status = num.tryParse(field[5]) ?? 0;
              GoalModel goalModel = GoalModel(
                  goal: goal, user: user, season: seasons.firstWhere((s) => s.seasonYear == DateTime.now().year));

              var newUser = user.copyWith(baseMyShareCredit: status, currentMyShareCredit: status);

              await goalRepository
                  .postGoal(goalModel)
                  .then((value) async => await usersRepository.updateUser(currentUserProvider.state!.id, newUser));
            }
          }
          rowNb++;
        }
      }
      state = state.copyWith(modelState: ModelState.success);
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: "Not supported: ${e.toString()}");
    }
  }

  Future<void> deleteGoal(num goalId) async {
    List<GoalModel> origItems = state.goals;
    List<GoalModel> items = [...origItems];
    items.removeWhere((a) => a.id != goalId);
    state = state.copyWith(goals: items, modelState: ModelState.processing);
    try {
      await goalRepository
          .deleteGoal(goalId, currentUserProvider.state!.id)
          .then((value) => state = state.copyWith(goals: items, modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, goals: origItems);
    }
  }

  Future<void> updateGoal(GoalModel goal) async {
    userController.text = "${goal.user?.getFullName()} (${goal.user?.getAge()}) ";
    state = state.copyWith(selectedGoal: goal);
  }

  Future<void> saveGoal() async {
    var mode = state.mode;
    state = state.copyWith(modelState: ModelState.processing);
    var goal = state.selectedGoal;
    try {
      if (goal.season != null && goal.user != null && goal.goal != 0) {
        if (mode == MaintenanceMode.create) {
          await goalRepository.postGoal(state.selectedGoal);
        } else if (mode == MaintenanceMode.edit) {
          await goalRepository.putGoal(state.selectedGoal, currentUserProvider.state!.id);
        }
        state = state.copyWith(selectedGoal: const GoalModel(goal: 0), modelState: ModelState.success);
      }
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> presetGoal(GoalModel goal, MaintenanceMode mode) async {
    if (goal.season == null) {
      await seasonRepository
          .getSeasons()
          .then((value) => goal = goal.copyWith(season: value.firstWhere((s) => s.seasonYear == DateTime.now().year)));
      userController.text = "";
    } else {
      userController.text = "${goal.user?.getFullName()} (${goal.user?.getAge()})";
    }
    state = state.copyWith(selectedGoal: goal, mode: mode);
  }

  Future<List<UserModel>> filterUsers(String filter) async {
    var users = await usersRepository.getUsers(null, true);
    var filtered = users
        .where((u) =>
            Utils.changeSpecChars(u.firstname.toLowerCase()).startsWith(Utils.changeSpecChars(filter.toLowerCase())) ||
            Utils.changeSpecChars(u.lastname.toLowerCase()).startsWith(Utils.changeSpecChars(filter.toLowerCase())) ||
            Utils.changeSpecChars("${u.lastname.toLowerCase()} ${u.firstname.toLowerCase()}")
                .startsWith(Utils.changeSpecChars(filter.toLowerCase())))
        .toList();
    filtered.sort((a, b) => (a.getFullName()).compareTo(b.getFullName()));
    return filtered;
  }

  Future<void> filterGoals(String filter) async {
    var goals = state.goals;
    state = state.copyWith(
        filtered: goals
            .where((goal) =>
                Utils.changeSpecChars(goal.user!.firstname.toLowerCase())
                    .startsWith(Utils.changeSpecChars(filter.toLowerCase())) ||
                Utils.changeSpecChars(goal.user!.lastname.toLowerCase())
                    .startsWith(Utils.changeSpecChars(filter.toLowerCase())) ||
                Utils.changeSpecChars("${goal.user!.lastname.toLowerCase()} ${goal.user!.firstname.toLowerCase()}")
                    .startsWith(Utils.changeSpecChars(filter.toLowerCase())))
            .toList());
  }
}
