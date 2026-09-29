import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentor_mentee/data/model/mentor_mentee_model.dart';

part 'mentor_mentee_state.freezed.dart';

@freezed
abstract class MentorMenteeState with _$MentorMenteeState {
  const factory MentorMenteeState({
    @Default([]) List<MentorMenteeModel> mentees,
    UserModel? mentor,
    UserModel? mentee,
    @Default(ModelState.empty) ModelState createState,
    @Default([]) List<UserModel> users,
    @Default(BaseListState()) BaseListState listState,
  }) = _MentorMenteeState;

  const MentorMenteeState._();
}
