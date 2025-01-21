import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/bufe/data/model/bufe_account_model.dart';
import 'package:work_hu/features/bufe/data/model/bufe_order_items_model.dart';
import 'package:work_hu/features/bufe/data/model/bufe_orders_model.dart';
import 'package:work_hu/features/bufe/data/model/bufe_payments_model.dart';

part 'bufe_state.freezed.dart';

@freezed
abstract class BufeState with _$BufeState {
  const factory BufeState(
      {@Default([]) List<BufePaymentsModel> payments,
      BufeAccountModel? account,
      @Default([]) List<BufeOrdersModel> orders,
      @Default([]) List<BufeOrderItemsModel> orderItems,
      BufeOrdersModel? selectedOrder,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _BufeState;

  const BufeState._();
}
