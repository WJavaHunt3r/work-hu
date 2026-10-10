import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/audit_log/data/model/audit_log_model.dart';
import 'package:work_hu/features/audit_log/widgets/audit_action_label.dart';
import 'package:work_hu/features/utils.dart';

/// Everything about one audit entry, including the details JSON (changed fields with old and new values).
class AuditLogDetailDialog extends StatelessWidget {
  const AuditLogDetailDialog({super.key, required this.entry});

  final AuditLogModel entry;

  String get _details {
    final details = entry.details;
    if (details == null) return "";
    if (details is String) return details;
    return const JsonEncoder.withIndent("  ").convert(details);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final details = _details;
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
          title: Row(
            children: [
              Text("audit_detail_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 12.sp),
              AuditActionLabel(entry.action),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Row("audit_time", Utils.dateToStringWithTime(entry.timestamp)),
              _Row(
                "audit_user",
                [entry.username ?? "audit_system".i18n(), if (entry.userId != null) "#${entry.userId}"].join("  "),
              ),
              _Row("audit_ip", entry.ipAddress ?? ""),
              _Row(
                "audit_entity",
                [entry.entityType ?? "", if (entry.entityId != null) "#${entry.entityId}"].join("  "),
              ),
              _Row("audit_request", entry.request ?? ""),
              SizedBox(height: 16.sp),
              Row(
                children: [
                  Text("audit_details".i18n(), style: theme.textTheme.titleMedium),
                  const Spacer(),
                  if (details.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => Clipboard.setData(ClipboardData(text: details)),
                    ),
                ],
              ),
              SizedBox(height: 8.sp),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: SelectableText(
                  details.isEmpty ? "audit_no_details".i18n() : details,
                  style: theme.textTheme.bodySmall?.copyWith(fontFamily: "monospace"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.labelKey, this.value);

  final String labelKey;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.sp,
            child: Text(labelKey.i18n(), style: theme.textTheme.bodySmall),
          ),
          Expanded(child: SelectableText(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
