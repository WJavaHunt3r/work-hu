import 'package:freezed_annotation/freezed_annotation.dart';

part 'bufe_payments_model.freezed.dart';

part 'bufe_payments_model.g.dart';

@freezed
class BufePaymentsModel with _$BufePaymentsModel {
  const factory BufePaymentsModel({required num userid, required String amount, required String date}) =
      _BufePaymentsModel;

  factory BufePaymentsModel.fromJson(Map<String, dynamic> json) => _$BufePaymentsModelFromJson(json);
}
