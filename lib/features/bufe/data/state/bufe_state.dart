import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/bufe/data/model/bufe_account_model.dart';
import 'package:work_hu/features/bufe/data/model/bufe_payments_model.dart';

part 'bufe_state.freezed.dart';

@freezed
abstract class BufeState with _$BufeState {
  const factory BufeState(
      {@Default([]) List<BufePaymentsModel> payments,
      @Default([]) List<BufeAccountModel> accounts,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _BufeState;

  const BufeState._();
}
