import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';

part 'bufe_transactions_state.freezed.dart';

@freezed
abstract class BufeTransactionsState with _$BufeTransactionsState {
  const factory BufeTransactionsState({
    @Default([]) List<OrderEntry> orders,
    @Default(BaseListState()) BaseListState listStatus,
  }) = _BufeTransactionsState;

  const BufeTransactionsState._();
}
