import 'package:freezed_annotation/freezed_annotation.dart';

part 'bufe_order_items_model.freezed.dart';

part 'bufe_order_items_model.g.dart';

@freezed
class BufeOrderItemsModel with _$BufeOrderItemsModel {
  const factory BufeOrderItemsModel({required String price, required String name, required num orderId}) =
      _BufeOrderItemsModel;

  factory BufeOrderItemsModel.fromJson(Map<String, dynamic> json) => _$BufeOrderItemsModelFromJson(json);
}
