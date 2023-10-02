import 'package:work_hu/features/create_transactions/data/api/create_transaction_api.dart';
import 'package:work_hu/features/create_transactions/data/models/transaction_item_model.dart';

class CreateTransactionsRepository {
  final CreateTransactionsApi _createTransactionApi;

  CreateTransactionsRepository(this._createTransactionApi);

  Future<TransactionItemModel> createTransactionItem(TransactionItemModel transactionItem) async {
    try {
      final res = await _createTransactionApi.createTransactionItem(transactionItem);
      return TransactionItemModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> sendTransactions(List<TransactionItemModel> items) async {
    try {
      final res = await _createTransactionApi.sendTransactions(items.map((e) => e.toJson()).toList());
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
