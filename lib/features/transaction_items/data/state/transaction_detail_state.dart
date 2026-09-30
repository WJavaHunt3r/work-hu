import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';

part 'transaction_detail_state.freezed.dart';

@freezed
abstract class TransactionDetailState with _$TransactionDetailState {
  const factory TransactionDetailState({TransactionModel? transaction, @Default(BaseState()) BaseState status}) =
      _TransactionDetailState;
}
