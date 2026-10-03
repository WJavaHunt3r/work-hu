import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'mentor_mentee_create_state.freezed.dart';

@freezed
abstract class MentorMenteeCreateState with _$MentorMenteeCreateState {
  const factory MentorMenteeCreateState({
    UserModel? mentor,
    UserModel? mentee,
    @Default([]) List<UserModel> users,
    @Default(BaseState()) BaseState status,
  }) = _MentorMenteeCreateState;
}
