import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/payment_status.dart';

part 'checkout_model.freezed.dart';
part 'checkout_model.g.dart';

/// A SumUp checkout as returned by the GM gateway.
///
/// Only what identifies the checkout and its outcome is required: SumUp leaves out some of the other fields
/// depending on the checkout's state (e.g. after a failed payment), and a missing one must not hide the result.
@freezed
abstract class CheckoutModel with _$CheckoutModel {
  const factory CheckoutModel({
    required num amount,
    required String checkout_reference,
    required String id,
    required String description,
    required PaymentStatus status,
    String? checkout_type,
    String? date,
    String? merchant_code,
    String? merchant_name,
    String? merchant_country,
    String? pay_to_email,
    String? purpose,
    String? hosted_checkout_url,
    @Default([]) List<dynamic> transactions,
  }) = _CheckoutModel;

  factory CheckoutModel.fromJson(Map<String, dynamic> json) => _$CheckoutModelFromJson(json);
}
