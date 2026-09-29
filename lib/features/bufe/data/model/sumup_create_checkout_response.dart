import 'package:freezed_annotation/freezed_annotation.dart';

part 'sumup_create_checkout_response.freezed.dart';
part 'sumup_create_checkout_response.g.dart';

@freezed
abstract class SumupCreateCheckoutResponse with _$SumupCreateCheckoutResponse {
  const factory SumupCreateCheckoutResponse({
    required String hosted_url,
    required num amount,
    required String checkout_reference,
    required String id,
    required String status,
  }) = _SumupCreateCheckoutResponse;

  factory SumupCreateCheckoutResponse.fromJson(Map<String, dynamic> json) =>
      _$SumupCreateCheckoutResponseFromJson(json);
}
