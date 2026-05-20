import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_items_filter.dart';

class TransactionItemsApi {
  final DioClient _dioClient = locator<DioClient>();

  TransactionItemsApi();

  Future<dynamic> getTransactionItems(
      {TransactionItemsFilter? filter, required int page, required int size, required List<String> sort}) async {
    try {
      final res = await _dioClient.dio.get("/transactionItem", queryParameters: {
        "transactionId": filter?.transactionId,
        "userId": filter?.userId,
        "roundId": filter?.roundId,
        "seasonYear": filter?.seasonYear,
        "startDate": filter?.startDate,
        "endDate": filter?.endDate,
        "transactionType": filter?.transactionType,
        "page": page,
        "size": size,
        "sort": sort
      });
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sendTransactions(List<Map<String, dynamic>> map) async {
    try {
      final res = await _dioClient.dio.post("/transactionItem/items", data: map);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteTransactionItem(num transactionItemId, num userId) async {
    try {
      final res = await _dioClient.dio.delete("/transactionItem/$transactionItemId", queryParameters: {"userId": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
