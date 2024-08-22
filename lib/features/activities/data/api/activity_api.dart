import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';

import '../../../../api/dio_client.dart';

class ActivityApi {
  final DioClient _dioClient = locator<DioClient>();

  ActivityApi();

  Future<List<dynamic>> getActivities(
      {num? responsibleId,
      num? employerId,
      num? createUserId,
      bool? registeredInApp,
      bool? registeredInMyShare,
      String? searchText}) async {
    try {
      final res = await _dioClient.dio.get("/activity", queryParameters: {
        "responsibleId": responsibleId,
        "employerId": employerId,
        "createUserId": createUserId,
        "registeredInApp": registeredInApp,
        "registeredInMyShare": registeredInMyShare,
        "searchText": searchText,
      });
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getActivity(num activityId) async {
    try {
      final res = await _dioClient.dio.get("/activity/$activityId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> registerActivity(num activityId, num userId) async {
    try {
      final res = await _dioClient.dio.post("/activity/$activityId/register", queryParameters: {"userId": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> registerActivityInTeams(num activityId, num userId) async {
    try {
      final res =
          await _dioClient.dio.post("/registerInTeams", queryParameters: {"activityId": activityId, "userId": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postActivity(ActivityModel activity) async {
    try {
      final res = await _dioClient.dio.post("/activity", data: activity.toJson());
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putActivity(ActivityModel activity, num activityId) async {
    try {
      final res = await _dioClient.dio.put("/activity/$activityId", data: activity.toJson());
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteActivity(num activityId, num userId) async {
    try {
      final res = await _dioClient.dio.delete("/activity/$activityId", queryParameters: {"userId": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
