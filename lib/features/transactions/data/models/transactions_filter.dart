import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_filter.freezed.dart';
part 'transactions_filter.g.dart';

@freezed
abstract class TransactionsFilter with _$TransactionsFilter {
  const factory TransactionsFilter({num? createUserId, String? dateFrom, String? dateTo, String? keyword}) =
      _TransactionsFilter;

  factory TransactionsFilter.fromJson(Map<String, dynamic> json) => _$TransactionsFilterFromJson(json);
}
