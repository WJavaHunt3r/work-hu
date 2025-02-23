import 'package:dio/dio.dart';
import 'package:work_hu/features/activities/data/api/activity_api.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/utils.dart';

class ActivityRepository {
  final ActivityApi _activityApi;

  ActivityRepository(this._activityApi);

  Future<List<ActivityModel>> getActivities(
      {num? responsibleId,
      num? employerId,
      num? createUserId,
      bool? registeredInApp,
      bool? registeredInMyShare,
      DateTime? referenceDate,
      String? searchText}) async {
    try {
      final res = await _activityApi.getActivities(
          registeredInApp: registeredInApp,
          registeredInMyShare: registeredInMyShare,
          responsibleId: responsibleId,
          createUserId: createUserId,
          employerId: employerId,
          referenceDate: referenceDate == null ? "" : Utils.dateToString(referenceDate),
          searchText: searchText);
      return res.map((e) => ActivityModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<ActivityModel> getActivity(num activityId) async {
    try {
      final res = await _activityApi.getActivity(activityId);
      return ActivityModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> registerActivity(num activityId, num userId) async {
    try {
      final res = await _activityApi.registerActivity(activityId, userId);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ActivityModel> postActivity(ActivityModel activity) async {
    try {
      final res = await _activityApi.postActivity(activity);
      return ActivityModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<ActivityModel> putActivity(ActivityModel activity, num activityId) async {
    try {
      final res = await _activityApi.putActivity(activity, activityId);
      return ActivityModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteActivity(num activityId, userId) async {
    try {
      final res = await _activityApi.deleteActivity(activityId, userId);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> registerActivityInTeams(num activityId, num userId) async {
    try {
      final res = await _activityApi.registerActivityInTeams(activityId, userId);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
