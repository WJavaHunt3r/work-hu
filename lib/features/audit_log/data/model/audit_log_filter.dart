import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_filter.freezed.dart';
part 'audit_log_filter.g.dart';

@freezed
abstract class AuditLogFilter with _$AuditLogFilter {
  const factory AuditLogFilter({
    String? action,
    String? entityType,
    String? username,
    DateTime? dateFrom,

    /// Inclusive.
    DateTime? dateTo,

    /// Matches the details and the request path.
    String? searchText,
  }) = _AuditLogFilter;

  factory AuditLogFilter.fromJson(Map<String, dynamic> json) => _$AuditLogFilterFromJson(json);
}
