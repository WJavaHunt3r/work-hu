import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/user_camps/data/model/user_camp_model.dart';

part 'user_camp_state.freezed.dart';

@freezed
abstract class UserCampState with _$UserCampState {
  const factory UserCampState(
      {@Default([]) List<UserCampModel> userCamps,
        @Default(BaseListState()) BaseListState listState,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _UserCampState;

  const UserCampState._();
}
