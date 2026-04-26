import 'package:dio/dio.dart';
import 'package:work_hu/features/bufe/data/api/bufe_api.dart';
import 'package:work_hu/features/bufe/data/model/sumup_checkout_model.dart';
import 'package:work_hu/features/bufe/data/model/sumup_create_checkout_response.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';

class BufeRepository {
  final BufeApi _bufeApi;

  BufeRepository(this._bufeApi);

  Future<TopUpResponse> getPayments({required num userId}) async {
    try {
      final res = await _bufeApi.getPayments(userId: userId);
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
      // return BufeAccountModel(name: "Wagner André", balance: 2000);
      rethrow;
    }
  }

  Future<Order> getOrders({required num userId}) async {
    try {
      final res = await _bufeApi.getOrders(userId: userId);
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

  // Future<CheckoutModel> getCheckout({required String checkoutId}) async {
  //   try {
  //     final res = await _bufeApi.getCheckout(checkoutId: checkoutId);
  //     return CheckoutModel.fromJson(res);
  //   } on DioException {
  //     rethrow;
  //   }
  // }
  //
  // Future<CheckoutModel> deleteCheckout({required String checkoutId}) async {
  //   try {
  //     final res = await _bufeApi.deleteCheckout(checkoutId: checkoutId);
  //     return CheckoutModel.fromJson(res);
  //   } on DioException {
  //     rethrow;
  //   }
  // }

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
