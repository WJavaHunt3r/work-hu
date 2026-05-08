import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/activities/data/model/activity_filter.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';

part 'activity_state.freezed.dart';

@freezed
abstract class ActivityState with _$ActivityState {
  const factory ActivityState(
      {@Default([]) List<ActivityModel> activities,
      @Default(ActivityFilter()) ActivityFilter filter,
      @Default(BaseListState()) BaseListState status}) = _ActivityState;

  const ActivityState._();
}
