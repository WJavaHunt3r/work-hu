import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default([]) List<UserRoundModel> userRounds,
    @Default(ModelState.empty) ModelState modelState,
  }) = _ProfileState;

  const ProfileState._();
}