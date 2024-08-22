import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';

import '../../../../api/dio_client.dart';

class ActivityItemsApi {
  final DioClient _dioClient = locator<DioClient>();

  ActivityItemsApi();

  Future<List<dynamic>> getActivityItems(
      {num? activityId, num? userId, num? roundId, bool? registeredInApp, String? searchText}) async {
    try {
      final res = await _dioClient.dio.get("/activityItem", queryParameters: {
        "activityId": activityId,
        "userId": userId,
        "roundId": roundId,
        "registeredInApp": registeredInApp,
        "searchText": searchText
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
      final res = await _dioClient.dio
          .put("/activityItem", queryParameters: {"activityItemId": activityItemId}, data: activityItem);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteActivityItems(num activityItemId, num userId) async {
    try {
      final res = await _dioClient.dio.delete("/activityItem/$activityItemId", queryParameters: {"userId": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
