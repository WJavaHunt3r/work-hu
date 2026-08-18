import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

part 'round_filter_chip_state.freezed.dart';

@freezed
abstract class RoundFilterChipState with _$RoundFilterChipState {
  const factory RoundFilterChipState(
      {@Default(RoundFilter()) RoundFilter filter,
      RoundModel? currentRound,
      @Default(BaseListState()) BaseListState status}) = _RoundFilterChipState;

  const RoundFilterChipState._();
}
