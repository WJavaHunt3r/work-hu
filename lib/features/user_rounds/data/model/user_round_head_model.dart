import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_round_head_model.freezed.dart';
part 'user_round_head_model.g.dart';

@freezed
abstract class UserRoundHeadModel with _$UserRoundHeadModel {
  const factory UserRoundHeadModel({
    required int onTrackCount,
    required int goalCount,
    required int churchGoal,
    required int localMyShareGoal,
    required int toOnTrackCount,
  }) = _UserRoundHeadModel;

  factory UserRoundHeadModel.fromJson(Map<String, dynamic> json) => _$UserRoundHeadModelFromJson(json);
}
