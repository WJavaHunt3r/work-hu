import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';

part 'transfer_amount_state.freezed.dart';

@freezed
abstract class TransferAmountState with _$TransferAmountState {
  const factory TransferAmountState({
    UserComboModel? selectedUser,
    SumupUserModel? account,
    @Default(0) num amount,
    @Default(BaseState()) BaseState status,
  }) = _TransferAmountState;

  const TransferAmountState._();
}
