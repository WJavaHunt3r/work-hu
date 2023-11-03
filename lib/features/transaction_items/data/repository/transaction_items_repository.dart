import 'package:dio/dio.dart';
import 'package:work_hu/features/transaction_items/data/api/transaction_items_api.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';

class TransactionItemsRepository {
  final TransactionItemsApi _transactionItemsApi;

  TransactionItemsRepository(this._transactionItemsApi);

  Future<List<TransactionItemModel>> getTransactionItems({num? transactionId, num? userId, num? roundId}) async {
    try {
      final res = await _transactionItemsApi.getTransactionItems(transactionId, userId, roundId);
      return res.map((e) => TransactionItemModel.fromJson(e)).toList();
    } on DioError catch (e) {
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
    } on DioError catch (e) {
      rethrow;
    }
  }
}
