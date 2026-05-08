import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';

import '../../../../app/framework/base_components/base_page_components/base_list_state.dart';

part 'activity_items_state.freezed.dart';

@freezed
abstract class ActivityItemsState with _$ActivityItemsState {
  const factory ActivityItemsState(
      {@Default([]) List<ActivityItemsModel> activityItems,
      ActivityModel? activity,
      @Default(BaseListState()) BaseListState status}) = _ActivityItemsState;

  const ActivityItemsState._();
}
