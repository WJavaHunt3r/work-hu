import 'package:freezed_annotation/freezed_annotation.dart';

part 'sumup_user_model.freezed.dart';
part 'sumup_user_model.g.dart';

@freezed
abstract class SumupUserModel with _$SumupUserModel {
  const factory SumupUserModel({
    required String full_name,
    required num balance,
    required String dukapp_id,
    required num spent,
    String? customer_code,
    String? staff_barcode,

    /// "YYYY-MM-DD" as the kiosk has it; null when unknown (the kiosk then refuses age-restricted products).
    String? birth_date,
  }) = _SumupUserModel;

  factory SumupUserModel.fromJson(Map<String, dynamic> json) => _$SumupUserModelFromJson(json);
}
