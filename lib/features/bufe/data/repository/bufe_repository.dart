import 'package:dio/dio.dart';
import 'package:work_hu/features/bufe/data/api/bufe_api.dart';
import 'package:work_hu/features/bufe/data/model/sumup_checkout_model.dart';
import 'package:work_hu/features/bufe/data/model/sumup_create_checkout_response.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';

class BufeRepository {
  final BufeApi _bufeApi;

  BufeRepository(this._bufeApi);

  Future<TopUpResponse> getPayments({required num userId, int? limit = 50, int? offset = 0}) async {
    try {
      final res = await _bufeApi.getPayments(userId: userId, limit: limit, offset: offset);
      return TopUpResponse.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<SumupUserModel> getAccount(num userId) async {
    try {
      final res = await _bufeApi.getAccount(userId);
      return SumupUserModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> getOrders({required num userId, int? limit = 50, int? offset = 0}) async {
    try {
      final res = await _bufeApi.getOrders(userId: userId, limit: limit, offset: offset);
      return Order.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<SumupCreateCheckoutResponse> createSumupCheckout(
      {required num amount,
      required String description,
      required num dukappId,
      required String redirectUrl,
      String? returnUrl}) async {
    try {
      final res = await _bufeApi.createSumupCheckout(
          returnUrl: returnUrl, amount: amount, dukappId: dukappId, description: description, redirectUrl: redirectUrl);
      return SumupCreateCheckoutResponse.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<SumupUserModel> createCustomer({
    required String fullname,
    required num dukappId,
    required String email,
  }) async {
    try {
      final res = await _bufeApi.createCustomer(fullname: fullname, dukappId: dukappId, email: email);
      return SumupUserModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<dynamic> deleteSumupCheckout({required String checkoutId}) async {
    try {
      final res = await _bufeApi.deleteSumupCheckout(checkoutId: checkoutId);
      return res;
    } on DioException {
      rethrow;
    }
  }

  Future<SumupCheckoutModel> getSumupCheckout({required String checkoutId}) async {
    try {
      final res = await _bufeApi.getSumupCheckout(checkoutId: checkoutId);
      return SumupCheckoutModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }
}
