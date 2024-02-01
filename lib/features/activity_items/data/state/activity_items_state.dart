import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';

part 'activity_items_state.freezed.dart';

@freezed
abstract class ActivityItemsState with _$ActivityItemsState {
  const factory ActivityItemsState(
      {@Default([]) List<ActivityItemsModel> activityItems,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _ActivityItemsState;

  const ActivityItemsState._();
}
