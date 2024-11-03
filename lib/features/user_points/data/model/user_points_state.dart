import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';

part 'user_points_state.freezed.dart';

@freezed
abstract class UserPointsState with _$UserPointsState{
  const factory UserPointsState({
    @Default([]) List<TransactionItemModel> transactionItems,
    @Default([]) List<ActivityItemsModel> activityItems,
    num? userId,
    @Default(ModelState.empty) ModelState modelState,
    @Default("") String message
  }) = _UserPointsState;

  const UserPointsState._();
}