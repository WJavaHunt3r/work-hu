import 'package:dio/dio.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

class RoundRepository {
  final RoundApi _roundApi;

  RoundRepository(this._roundApi);

  Future<PaginatedResponse<RoundModel>> getRounds({required RoundFilter filter, required PageStru pageStru}) async {
    try {
      final res = await _roundApi.getRounds(filter: filter, pageStru: pageStru);
      final paginatedData = PaginatedResponse<RoundModel>.fromJson(
        res,
        (json) => RoundModel.fromJson(json as Map<String, dynamic>),
      );

      return paginatedData;
    } on DioException {
      rethrow;
    }
  }

  Future<RoundModel> getCurrentRounds() async {
    try {
      final res = await _roundApi.getCurrentRound();
      return RoundModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<RoundModel> getRound([num? roundId]) async {
    try {
      final res = await _roundApi.getRound(roundId);
      return RoundModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<RoundModel> postRound({required RoundModel round}) async {
    try {
      final res = await _roundApi.postRound(round);
      return RoundModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<RoundModel> putRound(RoundModel round, num roundId) async {
    try {
      final res = await _roundApi.putRound(round, roundId);
      return RoundModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }
}
