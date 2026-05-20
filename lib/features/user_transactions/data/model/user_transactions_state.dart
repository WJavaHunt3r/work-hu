import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';

part 'user_transactions_state.freezed.dart';

@freezed
abstract class UserTransactionsState with _$UserTransactionsState{
  const factory UserTransactionsState({
    @Default([]) List<TransactionItemModel> transactionItems,
    DateTime? referenceDate,
    @Default([]) List<ActivityItemsModel> activityItems,

    num? userId,
    @Default(BaseListState()) BaseListState listState,
  }) = _UserTransactionsState;

  const UserTransactionsState._();
}