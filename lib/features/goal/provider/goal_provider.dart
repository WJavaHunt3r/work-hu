import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/goal/data/api/goal_api.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/data/state/goal_state.dart';
import 'package:work_hu/features/season/data/repository/season_repository.dart';
import 'package:work_hu/features/season/provider/season_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

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
  }

  final GoalRepository goalRepository;
  final UsersRepository usersRepository;
  final SeasonRepository seasonRepository;
  final UserDataNotifier currentUserProvider;

  Future<void> getGoals(num? seasonYear) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await goalRepository.getGoals(seasonYear).then((data) async {
        state = state.copyWith(goals: data, modelState: ModelState.success);
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
        var rowNb = 0;
        for (var row in fields) {
          if (rowNb != 0) {
            var field = row[0].split(";");
            var user = await usersRepository.getUserByMyShareId(num.tryParse(field[0]) ?? 0);
            if (!state.goals.any((element) => element.user.id == user.id)) {
              var goal = num.tryParse(field[6]) ?? 0;
              var status = num.tryParse(field[5]) ?? 0;
              var seasons = await seasonRepository.getSeasons();
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
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: "Not supported: ${e.toString()}");
    }
  }

  Future<void> deleteGoal(num goalId) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await goalRepository.deleteGoal(goalId, currentUserProvider.state!.id);
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }
}
