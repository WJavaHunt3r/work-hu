import 'package:dio/dio.dart';
import 'package:work_hu/features/goal/data/api/goal_api.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';

class GoalRepository {
  final GoalApi _goalApi;

  GoalRepository(this._goalApi);

  Future<List<GoalModel>> getGoals(num? seasonYear) async {
    try {
      final res = await _goalApi.getGoals(seasonYear);
      return res.map((e) => GoalModel.fromJson(e)).toList();
    } on DioError {
      rethrow;
    }
  }

  Future<GoalModel> getGoalByUserAndSeason(num userId, num seasonYear) async {
    try {
      final res = await _goalApi.getGoalByUserAndSeasonYear(userId, seasonYear);
      return GoalModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<GoalModel> getGoal(num goalId) async {
    try {
      final res = await _goalApi.getGoal(goalId);
      return GoalModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<GoalModel> postGoal(GoalModel goal) async {
    try {
      final res = await _goalApi.postGoal(goal);
      return GoalModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<GoalModel> putGoal(GoalModel goal, num goalId) async {
    try {
      final res = await _goalApi.putGoal(goal, goalId);
      return GoalModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteGoal(num goalId, userId) async {
    try {
      final res = await _goalApi.deleteGoal(goalId, userId);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
