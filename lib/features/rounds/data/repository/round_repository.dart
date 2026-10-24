import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

class RoundRepository {
  final RoundApi _roundApi;

  RoundRepository(this._roundApi);

  Future<PaginatedResponse<RoundModel>> getRounds(ListQuery<RoundFilter> query, {int page = 0}) async {
    try {
      final res = Map<String, dynamic>.from(await _roundApi.getRounds(query, page) as Map);
      // One round the app can't read (an old row with odd data) must not make the whole list fail: skip it
      final readable = <dynamic>[];
      for (final row in (res['content'] as List? ?? const [])) {
        try {
          RoundModel.fromJson(row as Map<String, dynamic>);
          readable.add(row);
        } catch (e) {
          debugPrint('Skipped a round that could not be read (id ${row is Map ? row['id'] : '?'}): $e');
        }
      }
      res['content'] = readable;
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

  /// Creates a round. Rounds can't be deleted (their points hang on them); an unwanted one is set inactive.
  Future<RoundModel> postRound(Map<String, dynamic> data) =>
      guardApi(() async => RoundModel.fromJson(await _roundApi.postRound(data) as Map<String, dynamic>));

  Future<RoundModel> putRound(num roundId, Map<String, dynamic> data) =>
      guardApi(() async => RoundModel.fromJson(await _roundApi.putRound(roundId, data) as Map<String, dynamic>));
}
