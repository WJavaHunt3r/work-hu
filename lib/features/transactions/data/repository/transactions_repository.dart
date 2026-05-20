import 'package:dio/dio.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/transactions/data/api/transaction_api.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/models/transactions_filter.dart';

class TransactionRepository {
  final TransactionApi _transactionApi;

  TransactionRepository(this._transactionApi);

  Future<TransactionModel> createTransaction(TransactionModel transaction, num userId) async {
    try {
      final res = await _transactionApi.createTransaction(transaction, userId);
      return TransactionModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<String> deleteTransaction(num transactionId, num userId) async {
    try {
      final res = await _transactionApi.deleteTransaction(transactionId, userId);
      return res;
    } on DioException {
      rethrow;
    }
  }

  Future<PaginatedResponse<TransactionModel>> getTransactions(
      {required TransactionsFilter filter, required PageStru pageStru}) async {
    try {
      final res = await _transactionApi.getTransactions(filter: filter, pageStru: pageStru);
      final paginatedData = PaginatedResponse<TransactionModel>.fromJson(
        res,
        (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
      );

      return paginatedData;
    } on DioException {
      rethrow;
    }
  }

  Future<TransactionModel> getTransaction(num transactionId) async {
    try {
      final res = await _transactionApi.getTransaction(transactionId);
      return TransactionModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }
}
