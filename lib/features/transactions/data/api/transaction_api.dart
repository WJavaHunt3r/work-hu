import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/models/transactions_filter.dart';

class TransactionApi {
  final DioClient _dioClient = locator<DioClient>();

  TransactionApi();

  Future<dynamic> createTransaction(TransactionModel transaction, num userId) async {
    try {
      final res = await _dioClient.dio.post("/transaction", data: transaction.toJson(), queryParameters: {"userId": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteTransaction(num transactionId, num userId) async {
    try {
      final res = await _dioClient.dio.delete("/transaction/$transactionId", queryParameters: {"userId": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTransactions({
    required TransactionsFilter filter,
    required PageStru pageStru,
  }) async {
    try {
      final res = await _dioClient.dio.get("/transaction", queryParameters: {...filter.toJson(), ...pageStru.toJson()});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTransaction(num transactionId) async {
    try {
      final res = await _dioClient.dio.get("/transaction/$transactionId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
