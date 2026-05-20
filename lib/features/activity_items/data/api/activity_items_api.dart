import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';

import '../../../../api/dio_client.dart';

class ActivityItemsApi {
  final DioClient _dioClient = locator<DioClient>();

  ActivityItemsApi();

  Future<dynamic> getActivityItems(
      {num? activityId,
      num? userId,
      num? roundId,
      bool? registeredInApp,
      String? searchText,
      int? size,
      int? page,
      SortBuilder? sort}) async {
    try {
      final res = await _dioClient.dio.get("/activityItem", queryParameters: {
        "activityId": activityId,
        "userId": userId,
        "roundId": roundId,
        "registeredInApp": registeredInApp,
        "searchText": searchText,
        "size": size,
        "page": page,
        "sort": sort?.build()
      });
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getActivityItem(num activityItemId) async {
    try {
      final res = await _dioClient.dio.get("/activityItem", queryParameters: {"activityItemId": activityItemId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postActivityItems(List<Map<String, dynamic>> activityItems) async {
    try {
      final res = await _dioClient.dio.post("/activityItem/items", data: activityItems);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postActivityItem(ActivityItemsModel activityItem) async {
    try {
      final res = await _dioClient.dio.post("/activityItem", data: activityItem);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putActivityItems(ActivityItemsModel activityItem, num activityItemId) async {
    try {
      final res =
          await _dioClient.dio.put("/activityItem", queryParameters: {"activityItemId": activityItemId}, data: activityItem);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteActivityItems(num activityItemId) async {
    try {
      final res = await _dioClient.dio.delete("/activityItem/$activityItemId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
