import 'package:dio/dio.dart';
import 'package:work_hu/features/profile/data/api/user_round_api.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';

class UserRoundRepository {
  final UserRoundApi _userApi;

  UserRoundRepository(this._userApi);

  Future<List<UserRoundModel>> fetchUserRounds({num? userId, num? roundId, num? seasonYear, num? paceTeam}) async {
    try {
      final res = await _userApi.fetchUserRoundsApiRequest(userId, roundId, seasonYear, paceTeam);
      return res.map((e) => UserRoundModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }
}
