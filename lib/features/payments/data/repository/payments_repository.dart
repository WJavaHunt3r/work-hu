import 'package:dio/dio.dart';
import 'package:work_hu/app/models/payment_goal.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/payments/data/api/payments_api.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';

class PaymentRepository {
  final PaymentsApi _paymentApi;

  PaymentRepository(this._paymentApi);

  Future<List<PaymentsModel>> getPayments(
      {num? userId,
      PaymentStatus? status,
      num? donationId,
      String? checkoutId,
      String? checkoutReference,
      DateTime? dateFrom,
      DateTime? dateTo,
      PaymentGoal? paymentGoal}) async {
    try {
      final res = await _paymentApi.getPayments(
          userId: userId,
          donationId: donationId,
          status: status,
          checkoutId: checkoutId,
          checkoutReference: checkoutReference,
          dateFrom: dateFrom?.toString().replaceAll(" ", "T"),
          dateTo: dateTo?.toString().replaceAll(" ", "T"),
          paymentGoal: paymentGoal);
      return res.map((e) => PaymentsModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<PaymentsModel> getPayment(num paymentId) async {
    try {
      final res = await _paymentApi.getPayment(paymentId);
      return PaymentsModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentsModel> postPayment(PaymentsModel payment) async {
    try {
      final res = await _paymentApi.postPayment(payment);
      return PaymentsModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentsModel> putPayment(PaymentsModel payment, num paymentId) async {
    try {
      final res = await _paymentApi.putPayment(payment, paymentId);
      return PaymentsModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deletePayment(num paymentId) async {
    try {
      final res = await _paymentApi.deletePayment(paymentId);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
