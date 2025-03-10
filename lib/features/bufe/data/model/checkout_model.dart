import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_model.freezed.dart';
part 'checkout_model.g.dart';

@freezed
class CheckoutModel with _$CheckoutModel {
  const factory CheckoutModel(
      {required num amount,
      required String checkout_reference,
      required String checkout_type,
      required String id,
      required String date,
      required String description,
      required String merchant_code,
      required String merchant_name,
      required String merchant_country,
      required String pay_to_email,
      required String status,
      required String porpuse,
      required List<dynamic> transactions}) = _CheckoutModel;

  factory CheckoutModel.fromJson(Map<String, dynamic> json) => _$CheckoutModelFromJson(json);
}
