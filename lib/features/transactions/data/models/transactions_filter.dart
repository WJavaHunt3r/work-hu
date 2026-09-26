import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/utils.dart';

part 'transactions_filter.freezed.dart';

part 'transactions_filter.g.dart';

@freezed
abstract class TransactionsFilter with _$TransactionsFilter {
  const factory TransactionsFilter({
    num? createUserId,
    String? dateFrom,
    String? dateTo,
    String? keyword,
  }) = _TransactionsFilter;

  factory TransactionsFilter.fromJson(Map<String, dynamic> json) => _$TransactionsFilterFromJson(json);
}
