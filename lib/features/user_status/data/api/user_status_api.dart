import 'package:work_hu/app/locator.dart';

import '../../../../api/dio_client.dart';

class UserStatusApi {
  final DioClient _dioClient = locator<DioClient>();

  UserStatusApi();

  Future<List<dynamic>> getUserStatuses(num? seasonYear, num? teamId) async {
    try {
      final res = await _dioClient.dio.get("/userStatus",
          queryParameters: {"seasonYear": seasonYear, "teamId": teamId});
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
      final res = await _dioClient.dio.get("/userStatus/user/$userId",
          queryParameters: {"seasonYear": seasonYear});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
