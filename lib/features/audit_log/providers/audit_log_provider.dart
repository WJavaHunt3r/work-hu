import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/audit_log/data/api/audit_log_api.dart';
import 'package:work_hu/features/audit_log/data/model/audit_log_filter.dart';
import 'package:work_hu/features/audit_log/data/model/audit_log_model.dart';
import 'package:work_hu/features/audit_log/data/repository/audit_log_repository.dart';

final auditLogApiProvider = Provider<AuditLogApi>((ref) => AuditLogApi());

final auditLogRepoProvider = Provider<AuditLogRepository>((ref) => AuditLogRepository(ref.read(auditLogApiProvider)));

final auditLogDataProvider =
    StateNotifierProvider.autoDispose<AuditLogDataNotifier, PagedState<AuditLogModel, AuditLogFilter>>(
      (ref) => AuditLogDataNotifier(ref.read(auditLogRepoProvider)),
    );

/// Actions and entity types the backend knows, for the filter chips.
final auditActionsProvider = FutureProvider.autoDispose<List<String>>(
  (ref) => ref.read(auditLogRepoProvider).getActions(),
);

final auditEntityTypesProvider = FutureProvider.autoDispose<List<String>>(
  (ref) => ref.read(auditLogRepoProvider).getEntityTypes(),
);

class AuditLogDataNotifier extends PagedListNotifier<AuditLogModel, AuditLogFilter> {
  AuditLogDataNotifier(this.repository)
    : super(
        ListQuery(
          filter: const AuditLogFilter(),
          // Newest first, which is also the backend's default.
          sort: const [SortOrder("timestamp", SortDir.desc)],
          size: 50,
        ),
      );

  final AuditLogRepository repository;

  @override
  List<SortOption> get sortOptions => const [
    SortOption(label: "audit_sort_time", properties: ["timestamp"]),
  ];

  @override
  Future<PaginatedResponse<AuditLogModel>> fetch(ListQuery<AuditLogFilter> query, int page) =>
      repository.getAuditLogs(query, page: page);
}
