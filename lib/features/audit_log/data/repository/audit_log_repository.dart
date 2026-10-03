import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/audit_log/data/api/audit_log_api.dart';
import 'package:work_hu/features/audit_log/data/model/audit_log_filter.dart';
import 'package:work_hu/features/audit_log/data/model/audit_log_model.dart';

class AuditLogRepository {
  AuditLogRepository(this._api);

  final AuditLogApi _api;

  Future<PaginatedResponse<AuditLogModel>> getAuditLogs(ListQuery<AuditLogFilter> query, {int page = 0}) =>
      guardApi(() async {
        final res = await _api.getAuditLogs(query, page);
        return PaginatedResponse<AuditLogModel>.fromJson(
          res,
          (json) => AuditLogModel.fromJson(json as Map<String, dynamic>),
        );
      });

  Future<List<String>> getActions() async => (await _api.getActions()).map((e) => e.toString()).toList();

  Future<List<String>> getEntityTypes() async => (await _api.getEntityTypes()).map((e) => e.toString()).toList();
}
