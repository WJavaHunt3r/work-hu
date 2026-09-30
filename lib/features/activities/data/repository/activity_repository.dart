import 'package:dio/dio.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/activities/data/api/activity_api.dart';
import 'package:work_hu/features/activities/data/model/activity_filter.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';

class ActivityRepository {
  final ActivityApi _activityApi;

  ActivityRepository(this._activityApi);

  Future<PaginatedResponse<ActivityModel>> getActivities(ListQuery<ActivityFilter> query, {int page = 0}) async {
    try {
      final res = await _activityApi.getActivities(query, page);
      final paginatedData = PaginatedResponse<ActivityModel>.fromJson(
        res,
        (json) => ActivityModel.fromJson(json as Map<String, dynamic>),
      );

      return paginatedData;
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
