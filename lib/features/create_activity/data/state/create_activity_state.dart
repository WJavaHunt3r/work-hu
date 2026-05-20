import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';

part 'create_activity_state.freezed.dart';

@freezed
abstract class CreateActivityState with _$CreateActivityState {
  const factory CreateActivityState({
    @Default([]) List<ActivityItemsModel> activityItems,
    ActivityModel? activity,
    @Default(0) num sum,
    UserComboModel? selectedUser,
    double? hours,
    @Default(1) double defaultHour,
    @Default(BaseState()) BaseState status,
  }) = _CreateActivityState;

  const CreateActivityState._();
}
