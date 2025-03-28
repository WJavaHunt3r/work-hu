import 'package:dio/dio.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/features/transaction_items/data/api/transaction_items_api.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';

class TransactionItemsRepository {
  final TransactionItemsApi _transactionItemsApi;

  TransactionItemsRepository(this._transactionItemsApi);

  Future<List<TransactionItemModel>> getTransactionItems(
      {num? transactionId,
      num? userId,
      num? roundId,
      num? seasonYear,
      DateTime? startDate,
      DateTime? endDate,
      TransactionType? transactionType}) async {
    try {
      final res = await _transactionItemsApi.getTransactionItems(
          transactionId, userId, roundId, seasonYear, startDate, endDate, transactionType);
      return res.map((e) => TransactionItemModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<String> sendTransactions(List<TransactionItemModel> items) async {
    try {
      final res = await _transactionItemsApi.sendTransactions(items.map((e) => e.toJson()).toList());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteTransactionItem(num transactionItemId, num userId) async {
    try {
      final res = await _transactionItemsApi.deleteTransactionItem(transactionItemId, userId);
      return res;
    } on DioException {
      rethrow;
    }
  }
}
