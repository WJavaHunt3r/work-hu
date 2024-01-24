import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';

part 'camp_state.freezed.dart';

@freezed
abstract class CampState with _$CampState {
  const factory CampState(
      {@Default([]) List<CampModel> goals,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _CampState;

  const CampState._();
}
