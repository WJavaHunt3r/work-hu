import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';

import '../../../../api/dio_client.dart';

class GoalApi {
  final DioClient _dioClient = locator<DioClient>();

  GoalApi();

  Future<List<dynamic>> getGoals(num? seasonYear) async {
    try {
      final res = await _dioClient.dio.get("/goals", queryParameters: {"seasonYear": seasonYear});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getGoalByUserAndSeasonYear(num userId, num seasonYear) async {
    try {
      final res =
          await _dioClient.dio.get("/userSeasonGoal", queryParameters: {"userId": userId, "seasonYear": seasonYear});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getGoal(num goalId) async {
    try {
      final res = await _dioClient.dio.get("/goal", queryParameters: {"goalId": goalId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postGoal(GoalModel goal) async {
    try {
      final res = await _dioClient.dio.post("/goal", data: goal);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putGoal(GoalModel goal, num goalId) async {
    try {
      final res = await _dioClient.dio.put("/goal", queryParameters: {"goalId": goalId}, data: goal);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteGoal(num goalId, num userId) async {
    try {
      final res = await _dioClient.dio.delete("/goal", queryParameters: {"goalId": goalId, "userId": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
