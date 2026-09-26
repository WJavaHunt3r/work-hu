import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

part 'user_filter.freezed.dart';

part 'user_filter.g.dart';

@freezed
abstract class UserFilter with _$UserFilter {
  const factory UserFilter({
    num? familyId,
    num? spouseId,
    num? teamId,
    num? churchId,
    String? keyword,
  }) = _UserFilter;

  factory UserFilter.fromJson(Map<String, dynamic> json) => _$UserFilterFromJson(json);
}
