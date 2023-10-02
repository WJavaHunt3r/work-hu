import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/create_transactions/data/models/transaction_item_model.dart';
import 'package:work_hu/features/home/data/model/team_model.dart';

class CreateTransactionsApi {
  final DioClient _dioClient = locator<DioClient>();

  CreateTransactionsApi();

  Future<dynamic> createTransactionItem(TransactionItemModel transactionItem) async {
    try {
      final res = await _dioClient.dio.post("/transactions", data: transactionItem.toJson());
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sendTransactions(List<Map<String, dynamic>> map) async {
    try {
      final res = await _dioClient.dio.post("/transactionItems", data: map);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
