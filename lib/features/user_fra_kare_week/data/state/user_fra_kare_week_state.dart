import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/user_fra_kare_week/data/model/user_fra_kare_week_model.dart';

part 'user_fra_kare_week_state.freezed.dart';

@freezed
abstract class UserFraKareWeekState with _$UserFraKareWeekState {
  const factory UserFraKareWeekState(
      {@Default([]) List<UserFraKareWeekModel> streaks,
      Map<num, UserFraKareWeekModel>? edits,
      num? selectedTeamId,
        @Default(0) num weekNumber,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _UserFraKareWeekkState;

  const UserFraKareWeekState._();
}
