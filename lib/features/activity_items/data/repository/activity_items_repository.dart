import 'package:dio/dio.dart';
import 'package:work_hu/features/activity_items/data/api/activity_items_api.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';

class ActivityItemsRepository {
  final ActivityItemsApi _activityApi;

  ActivityItemsRepository(this._activityApi);

  Future<List<ActivityItemsModel>> getActivityItems({num? activityId}) async {
    try {
      final res = await _activityApi.getActivities(activityId: activityId);
      return res.map((e) => ActivityItemsModel.fromJson(e)).toList();
    } on DioError {
      rethrow;
    }
  }

  Future<ActivityItemsModel> getActivityItem(num activityItemId) async {
    try {
      final res = await _activityApi.getActivityItems(activityItemId);
      return ActivityItemsModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> postActivityItems(List<ActivityItemsModel> activityItems) async {
    try {
      final res = await _activityApi.postActivityItems(activityItems.map((e) => e.toJson()).toList());
      return res;
    } catch (e) {
      rethrow;
    }
  }


  Future<ActivityItemsModel> postActivityItem(ActivityItemsModel activity) async {
    try {
      final res = await _activityApi.postActivityItem(activity);
      return ActivityItemsModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<ActivityItemsModel> putActivityItems(ActivityItemsModel activity, num activityId) async {
    try {
      final res = await _activityApi.putActivityItems(activity, activityId);
      return ActivityItemsModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteActivityItems(num activityId, userId) async {
    try {
      final res = await _activityApi.deleteActivityItems(activityId, userId);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
