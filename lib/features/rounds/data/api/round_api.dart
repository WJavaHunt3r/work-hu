import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

class RoundApi {
  final DioClient _dioClient = locator<DioClient>();

  RoundApi();

  Future<List<dynamic>> getRounds(num? seasonYear, bool? activeRounds) async {
    try {
      final res =
          await _dioClient.dio.get("/round", queryParameters: {"seasonYear": seasonYear, "activeRounds": activeRounds});
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
