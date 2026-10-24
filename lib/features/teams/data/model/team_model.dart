import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_model.freezed.dart';
part 'team_model.g.dart';

@freezed
abstract class TeamModel with _$TeamModel {
  const factory TeamModel({
    required num id,
    // A team (e.g. an old round's winner) can have no leader or coins stored
    @Default(0) num teamLeaderId,
    required String teamName,
    @Default(0) double coins,
    String? color,
    String? startColor,
    String? endColor,
    String? iconAssetPath,
  }) = _TeamModel;

  factory TeamModel.fromJson(Map<String, dynamic> json) => _$TeamModelFromJson(json);
}
