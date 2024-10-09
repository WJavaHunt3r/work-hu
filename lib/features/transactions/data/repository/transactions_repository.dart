import 'package:dio/dio.dart';
import 'package:work_hu/features/transactions/data/api/transaction_api.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';

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

  Future<List<TransactionModel>> getTransactions([num? roundId]) async {
    try {
      final res = await _transactionApi.getTransactions(roundId);
      return res.map((e) => TransactionModel.fromJson(e)).toList();
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
