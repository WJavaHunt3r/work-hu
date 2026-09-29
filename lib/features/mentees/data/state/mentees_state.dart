import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';

part 'mentees_state.freezed.dart';

@freezed
abstract class MenteesState with _$MenteesState {
  const factory MenteesState({
    @Default([]) List<UserGoalUserRoundModel> menteesStatus,
    @Default(BaseListState()) BaseListState listState,
  }) = _MenteesState;

  const MenteesState._();
}
