import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentor_mentee/data/model/mentor_mentee_model.dart';

part 'mentor_mentee_state.freezed.dart';

@freezed
abstract class MentorMenteeState with _$MentorMenteeState {
  const factory MentorMenteeState(
      {@Default([]) List<MentorMenteeModel> mentees,
        @Default(ModelState.empty) ModelState modelState,
        UserModel? mentor,
        UserModel? mentee,
        @Default(ModelState.empty) ModelState createState,
        @Default([]) List<UserModel> users,
        @Default("") String message}) = _MentorMenteeState;

  const MentorMenteeState._();
}