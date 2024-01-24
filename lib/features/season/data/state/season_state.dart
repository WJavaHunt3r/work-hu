import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';

part 'season_state.freezed.dart';

@freezed
abstract class SeasonState with _$SeasonState {
  const factory SeasonState(
      {@Default([]) List<SeasonModel> seasons,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _SeasonState;

  const SeasonState._();
}
