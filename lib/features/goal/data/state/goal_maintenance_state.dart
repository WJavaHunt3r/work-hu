import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';

part 'goal_maintenance_state.freezed.dart';

@freezed
abstract class GoalMaintenanceState with _$GoalMaintenanceState {
  const factory GoalMaintenanceState({
    @Default(GoalModel(goal: 0)) GoalModel selectedGoal,
    @Default(MaintenanceMode.create) MaintenanceMode mode,
  }) = _GoalMaintenanceState;
}
