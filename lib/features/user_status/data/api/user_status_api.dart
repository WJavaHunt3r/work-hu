import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/user_status/data/model/user_status_filter.dart';

import '../../../../api/dio_client.dart';

class UserStatusApi {
  final DioClient _dioClient = locator<DioClient>();

  UserStatusApi();

  Future<dynamic> getUserStatuses({required UserStatusFilter filter, required PageStru pageStru}) async {
    try {
      final res = await _dioClient.dio.get("/userStatus", queryParameters: {...filter.toJson(), ...pageStru.toJson()});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUserStatus(num userStatusId) async {
    try {
      final res = await _dioClient.dio.get("/userStatus/$userStatusId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUserStatusByUserId(num userId, num seasonYear) async {
    try {
      final res = await _dioClient.dio.get("/userStatus/user/$userId", queryParameters: {"seasonYear": seasonYear});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> setUserStatus(num seasonYear) async {
    try {
      final res = await _dioClient.dio.post("/userStatus/setUserStatus", queryParameters: {"seasonYear": seasonYear});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
