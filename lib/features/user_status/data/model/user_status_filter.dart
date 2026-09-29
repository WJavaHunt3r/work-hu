import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_status_filter.freezed.dart';
part 'user_status_filter.g.dart';

@freezed
abstract class UserStatusFilter with _$UserStatusFilter {
  const factory UserStatusFilter({num? teamId, String? keyword, num? seasonYear}) = _UserStatusFilter;

  factory UserStatusFilter.fromJson(Map<String, dynamic> json) => _$UserStatusFilterFromJson(json);
}
