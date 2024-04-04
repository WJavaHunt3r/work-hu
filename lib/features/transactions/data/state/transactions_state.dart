import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';

part 'transactions_state.freezed.dart';

@freezed
abstract class TransactionsState with _$TransactionsState {
  const factory TransactionsState(
      {@Default([]) List<TransactionModel> transactions,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message,
      @Default([]) List<RoundModel> rounds,
      @Default(0) num selectedRoundId}) = _TransactionsState;

  const TransactionsState._();
}
