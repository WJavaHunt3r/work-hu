import 'package:dio/dio.dart';
import 'package:work_hu/features/home/data/api/team_round_api.dart';
import 'package:work_hu/features/home/data/model/team_round_model.dart';

class TeamRoundRepository {
  final TeamRoundApi _teamApi;

  TeamRoundRepository(this._teamApi);

  Future<List<TeamRoundModel>> fetchTeamRounds() async {
    try {
      final res = await _teamApi.fetchTeamRoundsApiRequest();
      return res.map((e) => TeamRoundModel.fromJson(e)).toList();
    } on DioError catch (e) {
      rethrow;
    }
  }
}
