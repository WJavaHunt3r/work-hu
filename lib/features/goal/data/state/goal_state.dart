import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/goal/data/model/goal_model.dart';

part 'goal_state.freezed.dart';

@freezed
abstract class GoalState with _$GoalState {
  const factory GoalState(
      {@Default([]) List<GoalModel> goals,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _GoalState;

  const GoalState._();
}
