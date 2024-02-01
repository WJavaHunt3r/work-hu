import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';

part 'activity_state.freezed.dart';

@freezed
abstract class ActivityState with _$ActivityState {
  const factory ActivityState(
      {@Default([]) List<ActivityModel> activities,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _ActivityState;

  const ActivityState._();

  List<ActivityModel> getMyActivities(num userId, {bool? registeredInApp = false}) {
    return activities
        .where((a) => a.createUser.id == userId || a.responsible.id == userId && a.registeredInApp == registeredInApp)
        .toList();
  }

  List<ActivityModel> queryActivities(String pattern) {
    return activities.where((a) => a.toString().contains(pattern)).toList();
  }
}
