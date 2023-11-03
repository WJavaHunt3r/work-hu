import 'package:dio/dio.dart';
import 'package:work_hu/features/profile/data/api/user_round_api.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';

class UserRoundRepository {
  final UserRoundApi _userApi;

  UserRoundRepository(this._userApi);

  Future<List<UserRoundModel>> fetchUserRounds({num? userId, num? roundId}) async {
    try {
      final res = await _userApi.fetchUserRoundsApiRequest(userId, roundId);
      return res.map((e) => UserRoundModel.fromJson(e)).toList();
    } on DioError catch (e) {
      rethrow;
    }
  }
}
