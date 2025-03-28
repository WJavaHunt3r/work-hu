import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/locator.dart';

class TransactionItemsApi {
  final DioClient _dioClient = locator<DioClient>();

  TransactionItemsApi();

  Future<List<dynamic>> getTransactionItems(num? transactionId, num? userId, num? roundId, num? seasonYear, DateTime? startDate,
      DateTime? endDate, TransactionType? transactionType) async {
    try {
      final res = await _dioClient.dio.get("/transactionItem", queryParameters: {
        "transactionId": transactionId,
        "userId": userId,
        "roundId": roundId,
        "seasonYear": seasonYear,
        "startDate": startDate,
        "endDate": endDate,
        "transactionType": transactionType
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
