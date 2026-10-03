import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/audit_log/data/model/audit_log_filter.dart';
import 'package:work_hu/features/utils.dart';

class AuditLogApi {
  final DioClient _dioClient = locator<DioClient>();

  /// Needs the AUDIT_LOG_VIEW permission. Dates are sent as "yyyy-MM-dd" (the end date is inclusive).
  Future<dynamic> getAuditLogs(ListQuery<AuditLogFilter> query, int page) async {
    final filter = query.filter;
    String? text(String? value) => value == null || value.trim().isEmpty ? null : value.trim();
    final res = await _dioClient.dio.get(
      "/auditLog",
      queryParameters: {
        "action": filter.action,
        "entityType": filter.entityType,
        "username": text(filter.username),
        "dateFrom": filter.dateFrom == null ? null : Utils.dateToString(filter.dateFrom!),
        "dateTo": filter.dateTo == null ? null : Utils.dateToString(filter.dateTo!),
        "searchText": text(filter.searchText),
        ...query.pageParams(page),
      },
    );
    return res.data;
  }

  Future<List<dynamic>> getActions() async => (await _dioClient.dio.get("/auditLog/actions")).data;

  Future<List<dynamic>> getEntityTypes() async => (await _dioClient.dio.get("/auditLog/entityTypes")).data;
}
