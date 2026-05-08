import 'package:freezed_annotation/freezed_annotation.dart';

part 'sumup_user_model.freezed.dart';

part 'sumup_user_model.g.dart';

@freezed
class SumupUserModel with _$SumupUserModel {
  const factory SumupUserModel(
      {required String full_name,
      required num balance,
      required String dukapp_id,
      required num spent,
        String? customer_code,
      String? staff_barcode}) = _SumupUserModel;

  factory SumupUserModel.fromJson(Map<String, dynamic> json) => _$SumupUserModelFromJson(json);
}
