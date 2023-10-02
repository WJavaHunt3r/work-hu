import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/user_service.dart';
import 'package:work_hu/features/admin/data/models/transaction_model.dart';

class AdminApi {
  final DioClient _dioClient = locator<DioClient>();

  AdminApi();

  Future<dynamic> createTransaction(TransactionModel transaction) async {
    try {
      final res = await _dioClient.dio.post("/transaction",
          data: transaction.toJson(), queryParameters: {"userId": locator<UserService>().currentUser!.id});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteTransaction(num transactionId) async {
    try {
      final res = await _dioClient.dio.delete("/transaction",
          queryParameters: {"transactionId": transactionId, "userId": locator<UserService>().currentUser!.id});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getTransactionItems(num? transactionId, num? userId, num? roundId) async {
    try {
      final res = await _dioClient.dio.get("/transactionItems",
          queryParameters: {"transactionId": transactionId, "userId": userId, "roundId": roundId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getRound(num? roundId) async{
    try {
      final res = await _dioClient.dio.get("/round",
          queryParameters: {"roundId": roundId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
