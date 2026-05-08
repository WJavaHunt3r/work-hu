import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'activity_filter.g.dart';

part 'activity_filter.freezed.dart';

@freezed
class ActivityFilter with _$ActivityFilter {
  const factory ActivityFilter(
      {UserModel? createUser,
      String? description,
      DateTime? referenceDate,
      UserModel? employer,
      UserModel? responsible,
      bool? registeredInMyShare}) = _ActivityFilter;

  factory ActivityFilter.fromJson(Map<String, dynamic> json) => _$ActivityFilterFromJson(json);
}
