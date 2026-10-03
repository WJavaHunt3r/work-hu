import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';

part 'activity_detail_state.freezed.dart';

@freezed
abstract class ActivityDetailState with _$ActivityDetailState {
  const factory ActivityDetailState({ActivityModel? activity, @Default(BaseState()) BaseState status}) =
      _ActivityDetailState;
}
