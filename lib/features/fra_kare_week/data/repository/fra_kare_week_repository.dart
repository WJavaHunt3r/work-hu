import 'package:work_hu/features/fra_kare_week/data/api/fra_kare_week_api.dart';
import 'package:work_hu/features/fra_kare_week/data/model/fra_kare_week_model.dart';

class FraKareWeekRepository {
  final FraKareWeekApi _weekApi;

  FraKareWeekRepository(this._weekApi);

  Future<List<FraKareWeekModel>> getFraKareWeeks({num? year, num? weekNumber}) async {
    try {
      final res = await _weekApi.getFraKareWeeks(year, weekNumber);
      return res.map((s) => FraKareWeekModel.fromJson(s)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
