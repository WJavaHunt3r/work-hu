import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';

part 'bufe_state.freezed.dart';

@freezed
abstract class BufeState with _$BufeState {
  const factory BufeState(
      {@Default([]) List<TopUpEntry> payments,
      SumupUserModel? account,
      @Default([]) List<OrderEntry> orders,
      @Default([]) List<OrderItem> orderItems,
      OrderEntry? selectedOrder,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _BufeState;

  const BufeState._();
}
