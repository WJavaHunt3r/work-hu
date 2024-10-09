import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';

part 'transaction_items_state.freezed.dart';

@freezed
abstract class TransactionItemsState with _$TransactionItemsState {
  const factory TransactionItemsState({
    @Default([]) List<TransactionItemModel> transactionItems,
    @Default(0) num transactionId,
    TransactionModel? transaction,
    @Default(ModelState.empty) ModelState modelState,
    @Default("") String message
  }) = _TransactionItemsState;

  const TransactionItemsState._();
}
