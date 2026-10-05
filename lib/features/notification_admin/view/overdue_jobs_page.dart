import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/notification_admin/providers/notification_admin_provider.dart';

/// Users who are responsible for jobs that are over but still have no hours, with a button to remind them. The
/// automatic reminders (an hour after the end, and the next day) go out on their own; this is for the ones after that.
class OverdueJobsPage extends ConsumerWidget {
  const OverdueJobsPage({super.key});

  Future<void> _remind(BuildContext context, WidgetRef ref, List<num> userIds) async {
    try {
      final users = await ref.read(notificationAdminRepoProvider).remindOverdue(userIds);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("overdue_jobs_sent".i18n(["$users"]))));
      }
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    }
  }

  Future<void> _remindAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("overdue_jobs_remind_all".i18n()),
        content: Text("overdue_jobs_confirm_all".i18n()),
        actions: [
          TextButton(onPressed: () => dialogContext.pop(false), child: Text("base_cancel".i18n())),
          FilledButton(onPressed: () => dialogContext.pop(true), child: Text("overdue_jobs_remind".i18n())),
        ],
      ),
    );
    if (confirmed == true && context.mounted) await _remind(context, ref, const []);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overdue = ref.watch(overdueJobsProvider);
    final theme = Theme.of(context);
    final format = DateFormat("yyyy.MM.dd HH:mm");
    return Scaffold(
      appBar: AppBar(
        title: Text("overdue_jobs_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (overdue.value?.isNotEmpty ?? false)
            TextButton(onPressed: () => _remindAll(context, ref), child: Text("overdue_jobs_remind_all".i18n())),
        ],
      ),
      body: overdue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text("api_unknown_error".i18n())),
        data: (users) => RefreshIndicator(
          onRefresh: () async => ref.refresh(overdueJobsProvider.future),
          child: ListView(
            padding: EdgeInsets.all(16.sp),
            children: [
              Text("overdue_jobs_hint".i18n(), style: theme.textTheme.bodySmall),
              SizedBox(height: 12.sp),
              if (users.isEmpty)
                Padding(
                  padding: EdgeInsets.all(24.sp),
                  child: Center(child: Text("overdue_jobs_empty".i18n())),
                ),
              for (final user in users)
                Card(
                  margin: EdgeInsets.only(bottom: 12.sp),
                  child: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(user.userName, style: theme.textTheme.titleMedium)),
                            FilledButton.tonal(
                              onPressed: () => _remind(context, ref, [user.userId]),
                              child: Text("overdue_jobs_remind".i18n()),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.sp),
                        for (final job in user.jobs)
                          Padding(
                            padding: EdgeInsets.only(top: 4.sp),
                            child: Text(
                              "${job.description}${job.jobDateTime == null ? "" : " · ${format.format(job.jobDateTime!)}"}",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
