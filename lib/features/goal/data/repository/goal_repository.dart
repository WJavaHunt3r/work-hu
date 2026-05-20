import 'package:dio/dio.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/goal/data/api/goal_api.dart';
import 'package:work_hu/features/goal/data/model/goal_filter.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';

class GoalRepository {
  final GoalApi _goalApi;

  GoalRepository(this._goalApi);

  Future<PaginatedResponse<GoalModel>> getGoals({required GoalFilter filter, required PageStru pageStru}) async {
    try {
      final res = await _goalApi.getGoals(filter: filter, pageStru: pageStru);
      final paginatedData = PaginatedResponse<GoalModel>.fromJson(
        res,
        (json) => GoalModel.fromJson(json as Map<String, dynamic>),
      );
      return paginatedData;
    } on DioException {
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

  Future<GoalModel> putGoal(GoalModel goal, num userId) async {
    try {
      final res = await _goalApi.putGoal(goal, goal.id ?? 0, userId);
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
