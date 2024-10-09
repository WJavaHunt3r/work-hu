import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

part 'rounds_state.freezed.dart';

@freezed
abstract class RoundsState with _$RoundsState {
  const factory RoundsState(
      {@Default(0) num currentRoundNumber,
      @Default([]) List<RoundModel> rounds,
      RoundModel? currentRound,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _RoundsState;

  const RoundsState._();
}
