import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/create_transactions/data/models/transaction_item_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'create_transactions_state.freezed.dart';

@freezed
abstract class CreateTransactionsState with _$CreateTransactionsState {
  const factory CreateTransactionsState(
      {@Default([]) List<UserModel> users,
      @Default([]) List<TransactionItemModel> transactionItems,
      @Default(0) num transactionId,
      @Default(TransactionType.POINT) TransactionType transactionType,
      @Default(Account.OTHER) Account account,
      @Default("") String description,
      @Default(0) num sum,
      UserModel? selectedUser,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _CreateTransactionsState;

  const CreateTransactionsState._();
}
