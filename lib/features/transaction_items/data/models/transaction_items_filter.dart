import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';

part 'transaction_items_filter.freezed.dart';

part 'transaction_items_filter.g.dart';

@freezed
class TransactionItemsFilter with _$TransactionItemsFilter {
  const factory TransactionItemsFilter(
      {num? transactionId,
      num? userId,
      num? roundId,
      num? seasonYear,
      DateTime? startDate,
      DateTime? endDate,
      TransactionType? transactionType}) = _TransactionItemsFilter;

  factory TransactionItemsFilter.fromJson(Map<String, dynamic> json) => _$TransactionItemsFilterFromJson(json);
}
