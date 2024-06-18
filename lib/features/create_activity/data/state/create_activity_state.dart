import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'create_activity_state.freezed.dart';

@freezed
abstract class CreateActivityState with _$CreateActivityState {
  const factory CreateActivityState(
      {@Default([]) List<UserModel> users,
      @Default([]) List<ActivityItemsModel> activityItems,
      UserModel? responsible,
      UserModel? employer,
      DateTime? activityDate,
      @Default(TransactionType.DUKA_MUNKA) TransactionType transactionType,
      @Default(Account.MYSHARE) Account account,
      @Default("") String description,
      @Default(0) num sum,
      UserModel? selectedUser,
      @Default(ModelState.empty) ModelState modelState,
      @Default(true) bool isCollapsed,
      @Default(ModelState.empty) ModelState creationState,
      @Default("") String errorMessage}) = _CreateActivityState;

  const CreateActivityState._();
}
