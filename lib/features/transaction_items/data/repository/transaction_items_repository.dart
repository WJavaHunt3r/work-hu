import 'package:dio/dio.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/transaction_items/data/api/transaction_items_api.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';

import '../models/transaction_items_filter.dart';

class TransactionItemsRepository {
  final TransactionItemsApi _transactionItemsApi;

  TransactionItemsRepository(this._transactionItemsApi);

  Future<PaginatedResponse<TransactionItemModel>> getTransactionItems({
    TransactionItemsFilter? filter,
    required int page,
    required int size,
    required List<String> sort,
  }) async {
    try {
      final res = await _transactionItemsApi.getTransactionItems(filter: filter, page: page, size: size, sort: sort);
      final paginatedData = PaginatedResponse<TransactionItemModel>.fromJson(
        res,
        (json) => TransactionItemModel.fromJson(json as Map<String, dynamic>),
      );
      return paginatedData;
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
