import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class TransactionItemsApi {
  final DioClient _dioClient = locator<DioClient>();

  TransactionItemsApi();

  Future<List<dynamic>> getTransactionItems(num? transactionId, num? userId, num? roundId) async {
    try {
      final res = await _dioClient.dio.get("/transactionItems",
          queryParameters: {"transactionId": transactionId, "userId": userId, "roundId": roundId});
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

  Future<dynamic> deleteTransactionItem(num transactionItemId, num userId) async {
    try {
      final res = await _dioClient.dio
          .delete("/transactionItem", queryParameters: {"transactionItemId": transactionItemId, "userId": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
