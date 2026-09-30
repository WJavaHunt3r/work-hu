import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/activities/data/model/activity_filter.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/utils.dart';

import '../../../../api/dio_client.dart';

class ActivityApi {
  final DioClient _dioClient = locator<DioClient>();

  ActivityApi();

  Future<dynamic> getActivities(ListQuery<ActivityFilter> query, int page) async {
    final filter = query.filter;
    try {
      final res = await _dioClient.dio.get(
        "/activity",
        queryParameters: {
          "responsibleId": filter.responsible?.id,
          "employerId": filter.employer?.id,
          "createUserId": filter.createUser?.id,
          "registeredInMyShare": filter.registeredInMyShare,
          "referenceDate": filter.referenceDate == null ? "" : Utils.dateToString(filter.referenceDate!),
          "searchText": filter.description,
          ...query.pageParams(page),
        },
      );
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
      final res = await _dioClient.dio.post(
        "/activity/$activityId/registerInTeams",
        queryParameters: {"activityId": activityId, "userId": userId},
      );
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
