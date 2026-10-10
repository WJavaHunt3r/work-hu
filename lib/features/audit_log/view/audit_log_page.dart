import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/audit_log/data/model/audit_log_filter.dart';
import 'package:work_hu/features/audit_log/data/model/audit_log_model.dart';
import 'package:work_hu/features/audit_log/providers/audit_log_provider.dart';
import 'package:work_hu/features/audit_log/widgets/audit_action_label.dart';
import 'package:work_hu/features/audit_log/widgets/audit_log_detail_dialog.dart';
import 'package:work_hu/features/utils.dart';
import 'package:work_hu/app/platform/adaptive.dart';

/// Admin view of the audit log (needs AUDIT_LOG_VIEW): newest first, filterable by action, entity type, user, dates
/// and free text. Tap an entry to see its details.
class AuditLogPage extends BaseListPage {
  const AuditLogPage({super.key, super.title = "audit_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AuditLogPageState();
}

class AuditLogPageState extends PagedListPageState<AuditLogPage, AuditLogModel, AuditLogFilter, AuditLogDataNotifier> {
  @override
  get provider => auditLogDataProvider;

  @override
  Widget buildListTile(AuditLogModel item, int index) {
    final theme = Theme.of(context);
    final target = [
      if (item.entityType != null) item.entityType!,
      if (item.entityId != null) "#${item.entityId}",
    ].join(" ");
    return BaseListTile(
      index: index,
      isLast: index == items.length - 1,
      onTap: () => showDialog(
        context: context,
        builder: (_) => AuditLogDetailDialog(entry: item),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.username ?? "audit_system".i18n(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 8.sp),
          AuditActionLabel(item.action),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Utils.dateToStringWithTime(item.timestamp), style: theme.textTheme.bodySmall),
          if (target.isNotEmpty || item.request != null)
            Text(
              [if (target.isNotEmpty) target, if (item.request != null) item.request!].join("  ·  "),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- filters

  @override
  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) {
    final filter = state.query.filter;
    final hasDates = filter.dateFrom != null || filter.dateTo != null;
    return [
      _chip(
        label: hasDates
            ? "${filter.dateFrom == null ? "…" : Utils.dateToString(filter.dateFrom!)} – ${filter.dateTo == null ? "…" : Utils.dateToString(filter.dateTo!)}"
            : "audit_filter_dates".i18n(),
        active: hasDates,
        onTap: () => _pickDates(filter),
        onClear: () => notifier.setFilter(filter.copyWith(dateFrom: null, dateTo: null)),
      ),
      _chip(
        label: filter.username?.isNotEmpty == true
            ? "${"audit_filter_user".i18n()}: ${filter.username}"
            : "audit_filter_user".i18n(),
        active: filter.username?.isNotEmpty == true,
        onTap: () async {
          final text = await _askText("audit_filter_user", filter.username);
          if (text != null) notifier.setFilter(filter.copyWith(username: text.isEmpty ? null : text));
        },
        onClear: () => notifier.setFilter(filter.copyWith(username: null)),
      ),
      _chip(
        label: filter.searchText?.isNotEmpty == true
            ? "${"audit_filter_search".i18n()}: ${filter.searchText}"
            : "audit_filter_search".i18n(),
        active: filter.searchText?.isNotEmpty == true,
        onTap: () async {
          final text = await _askText("audit_filter_search", filter.searchText);
          if (text != null) notifier.setFilter(filter.copyWith(searchText: text.isEmpty ? null : text));
        },
        onClear: () => notifier.setFilter(filter.copyWith(searchText: null)),
      ),
    ];
  }

  @override
  List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) {
    final filter = state.query.filter;
    return [
      DialogFilterChip<String>(
        label: "audit_filter_action",
        labelValue: (action) => action == null ? null : auditActionLabel(action),
        initialValue: filter.action,
        onDeleted: () => notifier.setFilter(filter.copyWith(action: null)),
        onItemSelected: (action) => notifier.setFilter(filter.copyWith(action: action)),
        children: () => ref.read(auditActionsProvider.future),
        title: (action) => Text(auditActionLabel(action)),
      ),
      DialogFilterChip<String>(
        label: "audit_filter_entity",
        labelValue: (type) => type,
        initialValue: filter.entityType,
        onDeleted: () => notifier.setFilter(filter.copyWith(entityType: null)),
        onItemSelected: (type) => notifier.setFilter(filter.copyWith(entityType: type)),
        children: () => ref.read(auditEntityTypesProvider.future),
        title: (type) => Text(type),
      ),
    ];
  }

  Widget _chip({
    required String label,
    required bool active,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return InputChip(
      label: Text(label),
      selected: active,
      showCheckmark: false,
      onPressed: onTap,
      onDeleted: active ? onClear : null,
    );
  }

  Future<void> _pickDates(AuditLogFilter filter) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      initialDateRange: filter.dateFrom != null && filter.dateTo != null
          ? DateTimeRange(start: filter.dateFrom!, end: filter.dateTo!)
          : null,
    );
    if (range != null) notifier.setFilter(filter.copyWith(dateFrom: range.start, dateTo: range.end));
  }

  /// Asks for a line of text. Returns null when cancelled, an empty string to clear the filter.
  Future<String?> _askText(String labelKey, String? initial) {
    final controller = TextEditingController(text: initial ?? "");
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AdaptiveAlertDialog(
        title: Text(labelKey.i18n()),
        content: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value.trim()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text("base_cancel".i18n())),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
            child: Text("base_ok".i18n()),
          ),
        ],
      ),
    );
  }
}
