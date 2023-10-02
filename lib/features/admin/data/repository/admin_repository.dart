import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:work_hu/app/data/models/round_model.dart';
import 'package:work_hu/features/admin/data/api/admin_api.dart';
import 'package:work_hu/features/admin/data/models/transaction_model.dart';
import 'package:work_hu/features/create_transactions/data/models/transaction_item_model.dart';

class AdminRepository {
  final AdminApi _adminApi;

  AdminRepository(this._adminApi);

  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    try {
      final res = await _adminApi.createTransaction(transaction);
      return TransactionModel.fromJson(res);
    } on DioError catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String> deleteTransaction(num transactionId) async {
    try {
      final res = await _adminApi.deleteTransaction(transactionId);
      return res;
    } on DioError catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<TransactionItemModel>> getTransactionItems({num? transactionId, num? userId, num? roundId}) async {
    try {
      final res = await _adminApi.getTransactionItems(transactionId, userId, roundId);
      return res.map((e) => TransactionItemModel.fromJson(e)).toList();
    } on DioError catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RoundModel> getRound([num? roundId]) async {
    try {
      final res = await _adminApi.getRound(roundId);
      return RoundModel.fromJson(res);
    } on DioError catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
