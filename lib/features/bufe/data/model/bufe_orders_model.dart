import 'package:freezed_annotation/freezed_annotation.dart';

part 'bufe_orders_model.freezed.dart';

part 'bufe_orders_model.g.dart';

@freezed
class BufeOrdersModel with _$BufeOrdersModel {
  const factory BufeOrdersModel(
      {required num orderId,
      required String date,
      required String time,
      required String location,
      required String brutto}) = _BufeOrdersModel;

  factory BufeOrdersModel.fromJson(Map<String, dynamic> json) => _$BufeOrdersModelFromJson(json);
}
