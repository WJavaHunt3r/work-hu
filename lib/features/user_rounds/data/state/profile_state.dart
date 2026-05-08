import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/user_fra_kare_week/data/model/user_fra_kare_week_model.dart';
import 'package:work_hu/features/user_rounds/data/model/user_round_model.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default([]) List<UserModel> children,
    @Default([]) List<UserStatusModel> statuses,
    @Default([]) List<UserRoundModel> userRounds,
    @Default(BaseState()) BaseState status,
  }) = _ProfileState;

  const ProfileState._();
}
