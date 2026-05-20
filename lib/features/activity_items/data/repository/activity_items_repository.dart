import 'package:dio/dio.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/features/activity_items/data/api/activity_items_api.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';

class ActivityItemsRepository {
  final ActivityItemsApi _activityItemsApi;

  ActivityItemsRepository(this._activityItemsApi);

  Future<PaginatedResponse<ActivityItemsModel>> getActivityItems(
      {num? activityId,
      num? userId,
      num? roundId,
      bool? registeredInApp,
      String? searchText,
      int? size,
      int? page,
      SortBuilder? sort}) async {
    try {
      final res = await _activityItemsApi.getActivityItems(
          activityId: activityId,
          userId: userId,
          registeredInApp: registeredInApp,
          roundId: roundId,
          searchText: searchText,
          size: size,
          page: page,
          sort: sort);
      final paginatedData = PaginatedResponse<ActivityItemsModel>.fromJson(
        res,
        (json) => ActivityItemsModel.fromJson(json as Map<String, dynamic>),
      );
      return paginatedData;
    } on DioException {
      rethrow;
    }
  }

  Future<ActivityItemsModel> getActivityItem(num activityItemId) async {
    try {
      final res = await _activityItemsApi.getActivityItem(activityItemId);
      return ActivityItemsModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> postActivityItems(List<ActivityItemsModel> activityItems) async {
    try {
      final res = await _activityItemsApi.postActivityItems(activityItems.map((e) => e.toJson()).toList());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ActivityItemsModel> postActivityItem(ActivityItemsModel activity) async {
    try {
      final res = await _activityItemsApi.postActivityItem(activity);
      return ActivityItemsModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<ActivityItemsModel> putActivityItems(ActivityItemsModel activity, num activityId) async {
    try {
      final res = await _activityItemsApi.putActivityItems(activity, activityId);
      return ActivityItemsModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteActivityItems(num activityItemId) async {
    try {
      final res = await _activityItemsApi.deleteActivityItems(activityItemId);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
