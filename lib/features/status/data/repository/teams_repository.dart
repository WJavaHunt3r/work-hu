import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/features/status/data/api/team_api.dart';

import '../model/team_model.dart';

class TeamRepository {
  final TeamApi _teamApi;

  TeamRepository(this._teamApi);

  Future<List<TeamModel>> fetchTeams() async {
    try {
      final res = await _teamApi.fetchTeamsApiRequest();
      return res.map((e) => TeamModel.fromJson(e)).toList();
    } on DioError catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}