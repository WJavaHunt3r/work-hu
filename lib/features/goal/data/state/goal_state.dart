import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/goal/data/model/goal_filter.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';

part 'goal_state.freezed.dart';

@freezed
abstract class GoalState with _$GoalState {
  const factory GoalState(
      {@Default([]) List<GoalModel> goals,
        @Default(GoalFilter()) GoalFilter filter,
      @Default(BaseListState()) BaseListState listState,
      @Default(GoalModel(goal: 0)) GoalModel selectedGoal,
      @Default(MaintenanceMode.create) MaintenanceMode mode}) = _GoalState;

  const GoalState._();
}
