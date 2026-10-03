import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_model.freezed.dart';
part 'audit_log_model.g.dart';

/// One entry of the backend's audit log: who did what, when, from where.
@freezed
abstract class AuditLogModel with _$AuditLogModel {
  const factory AuditLogModel({
    required num id,
    required DateTime timestamp,

    /// CREATE, UPDATE, DELETE, LOGIN, ...; a string so actions added to the backend don't break parsing.
    required String action,
    String? entityType,
    String? entityId,
    num? userId,
    String? username,
    String? ipAddress,

    /// The request that caused the entry, e.g. "PUT /api/user/12".
    String? request,

    /// A JSON object (changed fields with old and new values, login method, ...), a plain string, or null.
    dynamic details,
  }) = _AuditLogModel;

  factory AuditLogModel.fromJson(Map<String, dynamic> json) => _$AuditLogModelFromJson(json);
}
