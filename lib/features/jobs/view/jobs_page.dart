import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/app/providers/locale_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';
import 'package:work_hu/features/jobs/data/model/job_filter.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/providers/jobs_provider.dart';
import 'package:work_hu/features/jobs/widgets/job_list_item.dart';
import 'package:work_hu/features/jobs/widgets/job_marker.dart';
import 'package:work_hu/features/jobs/widgets/user_filter_chip.dart';
import 'package:work_hu/features/utils.dart';

/// The job list. The Jobs tab ([manage] false) is for registering; the admin list ([manage] true) adds creating jobs
/// and every status, and opens the jobs with their management actions.
class JobsPage extends BaseListPage {
  const JobsPage({super.key, this.manage = false, super.title = "jobs_title"});

  final bool manage;

  /// Where the jobs of this list live: `/jobs/...` or `/admin/jobs/...`.
  static String basePath(bool manage) => manage ? "/admin/jobs" : "/jobs";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => JobsPageState();
}

class JobsPageState extends PagedListPageState<JobsPage, JobModel, JobFilter, JobsDataNotifier> {
  @override
  get provider => jobsDataProvider(widget.manage);

  String get _basePath => JobsPage.basePath(widget.manage);

  @override
  Widget buildListTile(JobModel item, int index) {
    if (widget.manage) return _buildAdminTile(item, index);
    return JobListItem(job: item, onTap: () => _open(item));
  }

  /// The admin list is a plain list like the others: one row per job, newest sort order decided by the sort menu.
  Widget _buildAdminTile(JobModel job, int index) {
    final theme = Theme.of(context);
    final people = [
      if (job.responsibleName != null && job.responsibleName!.isNotEmpty) job.responsibleName!,
      if (job.employerName != null && job.employerName!.isNotEmpty) job.employerName!,
    ].join("  ·  ");
    final places = job.maxParticipants == null
        ? "${job.registeredCount}"
        : "${job.registeredCount}/${job.maxParticipants}";
    return BaseListTile(
      index: index,
      isLast: index == items.length - 1,
      title: Text(job.description, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        [Utils.dateToStringWithTime(job.jobDateTime), if (people.isNotEmpty) people].join("\n"),
        style: theme.textTheme.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(places, style: theme.textTheme.titleSmall),
          if (job.status != JobStatus.OPEN)
            Text(job.status.label.i18n(), style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
        ],
      ),
      onTap: () => _open(job),
    );
  }

  /// Jobs grouped like the booking page: by week ("this week", "next week", ...), then by day inside a rounded box.
  /// Keeps the order of [items], so the sort menu still decides which comes first.
  @override
  Widget? buildListLayout(BuildContext context, WidgetRef ref) {
    // The admin list is a normal list, not grouped by day
    if (widget.manage) return null;
    final theme = Theme.of(context);
    final locale = ref.read(localeProvider).value?.languageCode;
    final weeks = <String, Map<DateTime, List<JobModel>>>{};
    for (final job in items) {
      final day = DateTime(job.jobDateTime.year, job.jobDateTime.month, job.jobDateTime.day);
      weeks.putIfAbsent(_weekKey(day), () => {}).putIfAbsent(day, () => []).add(job);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final week in weeks.entries) ...[
          Padding(
            padding: EdgeInsets.only(top: 16.sp, bottom: 12.sp),
            child: Text(week.key.i18n(), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          ),
          for (final day in week.value.entries)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 12.sp),
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24.sp),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.sp, bottom: 12.sp),
                    child: SpacedHeader(DateFormat("EEEE · dd. MMMM", locale).format(day.key)),
                  ),
                  for (final job in day.value) JobListItem(job: job, onTap: () => _open(job)),
                ],
              ),
            ),
        ],
      ],
    );
  }

  /// Weeks start on Monday. Jobs before this week are still open ones waiting to be completed.
  String _weekKey(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime monday(DateTime d) => DateTime(d.year, d.month, d.day - (d.weekday - 1));
    final weeks = monday(day).difference(monday(today)).inDays ~/ 7;
    if (weeks < 0) return "jobs_earlier";
    if (weeks == 0) return "jobs_this_week";
    if (weeks == 1) return "jobs_next_week";
    return "jobs_later";
  }

  /// Registrations change the counts shown in the list, so it reloads whenever the detail page closes.
  void _open(JobModel job) => context.push("$_basePath/${job.id}").then((_) => notifier.reload());

  @override
  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) {
    final filter = state.query.filter;
    return [
      FilterChip(
        label: Text("jobs_filter_open_only".i18n()),
        selected: filter.openOnly,
        onSelected: (value) => notifier.setFilter(filter.copyWith(openOnly: value)),
      ),
      FilterChip(
        label: Text("jobs_filter_mine".i18n()),
        selected: filter.onlyMine,
        onSelected: (value) => notifier.setFilter(filter.copyWith(onlyMine: value)),
      ),
      if (widget.manage) ...[
        UserFilterChip(
          label: "jobs_filter_responsible",
          userName: filter.responsibleName,
          onSelected: (user) =>
              notifier.setFilter(filter.copyWith(responsibleId: user.id, responsibleName: user.getFullName())),
          onDeleted: () => notifier.setFilter(filter.copyWith(responsibleId: null, responsibleName: null)),
        ),
        UserFilterChip(
          label: "jobs_filter_employer",
          userName: filter.employerName,
          onSelected: (user) =>
              notifier.setFilter(filter.copyWith(employerId: user.id, employerName: user.getFullName())),
          onDeleted: () => notifier.setFilter(filter.copyWith(employerId: null, employerName: null)),
        ),
      ],
    ];
  }

  /// The tab lists open jobs only (the notifier's default filter); finished and cancelled ones are for the admin list.
  @override
  List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) {
    if (!widget.manage) return [];
    final filter = state.query.filter;
    return [
      DialogFilterChip<JobStatus>(
        label: "jobs_filter_status",
        labelValue: (status) => status?.label.i18n(),
        initialValue: filter.status,
        onDeleted: () => notifier.setFilter(filter.copyWith(status: null)),
        onItemSelected: (status) => notifier.setFilter(filter.copyWith(status: status)),
        children: () async => JobStatus.values,
        title: (status) => Text(status.label.i18n()),
      ),
    ];
  }

  /// Jobs are created in the admin list, by users who may create them.
  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    final user = ref.read(userDataProvider).user;
    if (!widget.manage || user == null || !user.hasPermission(Permission.JOB_CREATE)) return null;
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => context.push("$_basePath/create").then((value) => value == true ? notifier.reload() : null),
    );
  }
}
