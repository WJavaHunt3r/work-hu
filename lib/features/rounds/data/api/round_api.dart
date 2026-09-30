import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

class RoundApi {
  final DioClient _dioClient = locator<DioClient>();

  RoundApi();

  Future<dynamic> getRounds(ListQuery<RoundFilter> query, int page) async {
    try {
      final res = await _dioClient.dio.get(
        "/round",
        queryParameters: {...query.filter.toJson(), ...query.pageParams(page)},
      );
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCurrentRound() async {
    try {
      final res = await _dioClient.dio.get("/round/currentRound");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getRound(num? roundId) async {
    try {
      final res = await _dioClient.dio.get("/round/$roundId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postRound(RoundModel round) async {
    try {
      final res = await _dioClient.dio.get("/round");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putRound(RoundModel round, num roundId) async {
    try {
      final res = await _dioClient.dio.get("/round/$roundId", data: round.toJson());
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
