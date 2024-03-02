import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'mentor_mentee_model.freezed.dart';

part 'mentor_mentee_model.g.dart';

@freezed
class MentorMenteeModel with _$MentorMenteeModel {
  const factory MentorMenteeModel({num? id, required UserModel mentor, required UserModel mentee}) = _MentorMenteeModel;

  factory MentorMenteeModel.fromJson(Map<String, dynamic> json) => _$MentorMenteeModelFromJson(json);
}
