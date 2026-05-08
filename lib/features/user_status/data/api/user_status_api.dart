import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/locator.dart';

import '../../../../api/dio_client.dart';

class UserStatusApi {
  final DioClient _dioClient = locator<DioClient>();

  UserStatusApi();

  Future<dynamic> getUserStatuses(
    num? seasonYear,
    num? teamId, {
    required int page,
    required int size,
    required SortBuilder sort,
  }) async {
    try {
      final res = await _dioClient.dio.get("/userStatus", queryParameters: {
        "seasonYear": seasonYear, "teamId": teamId, "page": page, // The page index (starts at 0 by default)
        "size": size, // How many items per page
        "sort": sort.build(),
      });
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
