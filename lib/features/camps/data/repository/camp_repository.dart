import 'package:dio/dio.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/camps/data/api/camps_api.dart';
import 'package:work_hu/features/camps/data/model/camp_filter.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';

class CampRepository {
  final CampApi _campApi;

  CampRepository(this._campApi);

  Future<PaginatedResponse<CampModel>> getCamps(ListQuery<CampFilter> query, {int page = 0}) async {
    try {
      final res = await _campApi.getCamps(query, page);
      final paginatedData = PaginatedResponse<CampModel>.fromJson(
        res,
        (json) => CampModel.fromJson(json as Map<String, dynamic>),
      );
      return paginatedData;
    } on DioException {
      rethrow;
    }
  }

  Future<CampModel> getCamp(num campId) async {
    try {
      final res = await _campApi.getCamp(campId);
      return CampModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<CampModel> postCamp(CampModel camp) async {
    try {
      final res = await _campApi.postCamp(camp);
      return CampModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<CampModel> putCamp(CampModel camp, num campId) async {
    try {
      final res = await _campApi.putCamp(camp, campId);
      return CampModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteCamp(num campId) async {
    try {
      final res = await _campApi.deleteCamp(campId);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
