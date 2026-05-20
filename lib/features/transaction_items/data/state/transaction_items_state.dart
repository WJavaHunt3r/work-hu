import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';

part 'transaction_items_state.freezed.dart';

@freezed
abstract class TransactionItemsState with _$TransactionItemsState {
  const factory TransactionItemsState({
    @Default([]) List<TransactionItemModel> transactionItems,
    TransactionModel? transaction,
    @Default(BaseListState()) BaseListState listState,
  }) = _TransactionItemsState;

  const TransactionItemsState._();
}
