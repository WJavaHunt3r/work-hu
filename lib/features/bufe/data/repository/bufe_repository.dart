import 'package:dio/dio.dart';
import 'package:work_hu/features/activities/data/api/activity_api.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/bufe/data/api/bufe_api.dart';
import 'package:work_hu/features/bufe/data/model/bufe_account_model.dart';
import 'package:work_hu/features/bufe/data/model/bufe_payments_model.dart';
import 'package:work_hu/features/utils.dart';

class BufeRepository {
  final BufeApi _bufeApi;

  BufeRepository(this._bufeApi);

  Future<List<BufePaymentsModel>> getPayments({required num bufeId}) async {
    try {
      final res = await _bufeApi.getPayments(bufeId: bufeId);
      return res.map((e) => BufePaymentsModel.fromJson(e)).toList();
    } on DioException {
      // return [
      //   BufePaymentsModel(userid: 250, amount: 5000, date: DateTime(2024, 05, 03)),
      //   BufePaymentsModel(userid: 250, amount: 3000, date: DateTime(2024, 10, 03))
      // ];
      rethrow;
    }
  }

  Future<BufeAccountModel> getBufeAccount(num bufeId) async {
    try {
      final res = await _bufeApi.getBufeAccount(bufeId);
      return BufeAccountModel.fromJson(res);
    } catch (e) {
      // return BufeAccountModel(name: "Wagner André", balance: 2000);
      rethrow;
    }

  }
}
