import 'package:dio/dio.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/camps/data/api/camps_api.dart';
import 'package:work_hu/features/camps/data/model/camp_filter.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';

class CampRepository {
  final CampApi _campApi;

  CampRepository(this._campApi);

  Future<PaginatedResponse<CampModel>> getCamps({required CampFilter filter, required PageStru pageStru}) async {
    try {
      final res = await _campApi.getCamps(filter: filter, pageStru: pageStru);
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
