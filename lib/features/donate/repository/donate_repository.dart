import 'package:dio/dio.dart';
import 'package:work_hu/features/donate/data/api/donate_api.dart';
import 'package:work_hu/features/donate/model/checkout_model.dart';

class DonateRepository{
  final DonateApi _donateApi;

  DonateRepository(this._donateApi);

  Future<CheckoutModel> getCheckout({required String checkoutId}) async {
    try {
      final res = await _donateApi.getCheckout(checkoutId: checkoutId);
      return CheckoutModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<CheckoutModel> deleteCheckout({required String checkoutId}) async {
    try {
      final res = await _donateApi.deleteCheckout(checkoutId: checkoutId);
      return CheckoutModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<CheckoutModel> createCheckout(
      {required num amount,
        required String checkoutReference,
        required String description,
        required String redirectUrl,
        String? returnUrl}) async {
    try {
      final res = await _donateApi.createCheckout(
          returnUrl: returnUrl,
          amount: amount,
          checkoutReference: checkoutReference,
          description: description,
          redirectUrl: redirectUrl);
      return CheckoutModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }
}