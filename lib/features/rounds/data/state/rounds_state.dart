import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

part 'rounds_state.freezed.dart';

@freezed
abstract class RoundsState with _$RoundsState {
  const factory RoundsState(
      {@Default([]) List<RoundModel> rounds,
      @Default(RoundFilter(activeRound: true)) RoundFilter filter,
      @Default(BaseListState()) BaseListState status,
      @Default(BaseState()) BaseState maintenanceStatus}) = _RoundsState;

  const RoundsState._();
}
