import 'package:dio/dio.dart';
import 'package:work_hu/features/teams/data/api/team_api.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

class TeamRepository {
  final TeamApi _teamApi;

  TeamRepository(this._teamApi);

  Future<List<TeamModel>> fetchTeams() async {
    try {
      final res = await _teamApi.getTeams();
      return res.map((e) => TeamModel.fromJson(e)).toList();
    } on DioError {
      rethrow;
    }
  }
}
