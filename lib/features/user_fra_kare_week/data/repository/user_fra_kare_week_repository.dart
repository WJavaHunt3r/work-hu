import 'package:work_hu/features/user_fra_kare_week/data/api/user_fra_kare_week_api.dart';
import 'package:work_hu/features/user_fra_kare_week/data/model/user_fra_kare_week_model.dart';

class UserFraKareWeekRepository {
  final UserFraKareWeekApi _weekApi;

  UserFraKareWeekRepository(this._weekApi);

  Future<List<UserFraKareWeekModel>> getFraKareWeeks(
      {num? userId, num? weekNumber, bool? listened, num? teamId, num? year}) async {
    try {
      final res = await _weekApi.getUserFraKareWeeks(userId, weekNumber, listened, teamId, year);
      return res.map((s) => UserFraKareWeekModel.fromJson(s)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserFraKareWeekModel> putFraKareWeek(bool listened, num weekId) async {
    try {
      final res = await _weekApi.putUserFraKareWeek(listened, weekId);
      return UserFraKareWeekModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteFraKareWeek(num weekId) async {
    try {
      final res = await _weekApi.deleteFraKareWeek(weekId);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
