import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/models/transactions_filter.dart';

part 'transactions_state.freezed.dart';

@freezed
abstract class TransactionsState with _$TransactionsState {
  const factory TransactionsState(
      {@Default([]) List<TransactionModel> transactions,
        @Default(TransactionsFilter()) TransactionsFilter filter,
      @Default(BaseListState()) BaseListState listState,
      @Default([]) List<RoundModel> rounds}) = _TransactionsState;

  const TransactionsState._();
}
