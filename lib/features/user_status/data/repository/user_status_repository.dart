import 'package:dio/dio.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/user_status/data/model/user_status_filter.dart';

import '../api/user_status_api.dart';
import '../model/user_status_model.dart';

class UserStatusRepository {
  final UserStatusApi _userStatusApi;

  UserStatusRepository(this._userStatusApi);

  Future<PaginatedResponse<UserStatusModel>> getUserStatuses(ListQuery<UserStatusFilter> query, {int page = 0}) async {
    try {
      final res = await _userStatusApi.getUserStatuses(query, page);
      final paginatedData = PaginatedResponse<UserStatusModel>.fromJson(
        res,
        (json) => UserStatusModel.fromJson(json as Map<String, dynamic>),
      );

      return paginatedData;
    } on DioException {
      rethrow;
    }
  }

  Future<UserStatusModel> getUserStatus(num userStatusId) async {
    try {
      final res = await _userStatusApi.getUserStatus(userStatusId);
      return UserStatusModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserStatusModel> getUserStatusByUserId(num userStatusId, num seasonYear) async {
    try {
      final res = await _userStatusApi.getUserStatusByUserId(userStatusId, seasonYear);
      return UserStatusModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> setUserStatus(num seasonYear) async {
    try {
      final res = await _userStatusApi.setUserStatus(seasonYear);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
