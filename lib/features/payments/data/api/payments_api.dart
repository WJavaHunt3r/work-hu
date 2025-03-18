import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/data/state/payments_state.dart';

import '../../../../api/dio_client.dart';

class PaymentsApi {
  final DioClient _dioClient = locator<DioClient>();

  PaymentsApi();

  Future<List<dynamic>> getPayments({num? userId, PaymentStatus? status, num? donationId}) async {
    try {
      final res =
          await _dioClient.dio.get("/payments", queryParameters: {"userId": userId, "donationId": donationId, "status": status});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPayment(num paymentId) async {
    try {
      final res = await _dioClient.dio.get("/payments/$paymentId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postPayment(PaymentsModel payment) async {
    try {
      final res = await _dioClient.dio.post("/payments", data: payment.toJson());
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putPayment(PaymentsModel payment, num paymentId) async {
    try {
      final res = await _dioClient.dio.put("/payments/$paymentId", data: payment.toJson());
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deletePayment(num paymentId) async {
    try {
      final res = await _dioClient.dio.delete("/payments/$paymentId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
