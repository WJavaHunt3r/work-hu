import 'package:freezed_annotation/freezed_annotation.dart';

part 'sumup_transactions.freezed.dart';

part 'sumup_transactions.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum EntryType { topup, purchase, unknown }

@freezed
class TopUpResponse with _$TopUpResponse {
  const factory TopUpResponse(
      {required List<TopUpEntry> items,
      @JsonKey(name: 'dukapp_id') required String dukappId,
      @JsonKey(name: 'customer_id') required String customerId,
      required int offset,
      required int limit,
      required int total}) = _TopUpResponse;

  factory TopUpResponse.fromJson(Map<String, dynamic> json) => _$TopUpResponseFromJson(json);
}

@freezed
class TopUpEntry with _$TopUpEntry {
  const factory TopUpEntry({
    required String id,
    required double amount,
    @JsonKey(name: 'date') required DateTime createdAt,
    required String description,
    required String type,
    @JsonKey(name: 'balance_after') required double balanceAfter,
  }) = _TopUpEntry;

  factory TopUpEntry.fromJson(Map<String, dynamic> json) => _$TopUpEntryFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order(
      {required List<OrderEntry> items,
      @JsonKey(name: 'dukapp_id') required String dukappId,
      @JsonKey(name: 'customer_id') required String customerId,
      required num offset,
      required num limit,
      required num total}) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required int quantity,
    required List<dynamic> modifiers,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'product_name') required String productName,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

@freezed
class OrderEntry with _$OrderEntry {
  const factory OrderEntry({
    required int total,
    @JsonKey(name: 'items') required List<OrderItem> orderItems,
    required DateTime date,
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'location_name') required String locationName,
    @JsonKey(name: 'discount_amount') required int discountAmount,
  }) = _OrderEntry;

  factory OrderEntry.fromJson(Map<String, dynamic> json) => _$OrderEntryFromJson(json);
}

@freezed
class DukappImages with _$DukappImages {
  const factory DukappImages({
    required String id,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'starts_at') required String startsAt,
    @JsonKey(name: 'ends_at') String? endsAt,
    @JsonKey(name: 'sort_order') required int sortOrder,
  }) = _DukappImages;

  factory DukappImages.fromJson(Map<String, dynamic> json) => _$DukappImagesFromJson(json);
}
