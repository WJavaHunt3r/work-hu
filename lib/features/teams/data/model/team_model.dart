import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_model.freezed.dart';

part 'team_model.g.dart';

@freezed
class TeamModel with _$TeamModel {
  const factory TeamModel(
      {required num id,
      required num teamLeaderId,
      required String teamName,
      required double coins,
      String? color,
      String? iconAssetPath}) = _TeamModel;

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);
}
