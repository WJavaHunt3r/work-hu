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
import 'package:work_hu/features/jobs/data/model/job_enums.dart';
import 'package:work_hu/features/jobs/data/model/job_filter.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/providers/jobs_provider.dart';
import 'package:work_hu/features/jobs/widgets/job_list_item.dart';
import 'package:work_hu/features/jobs/widgets/job_marker.dart';

class JobsPage extends BaseListPage {
  const JobsPage({super.key, super.title = "jobs_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => JobsPageState();
}

class JobsPageState extends PagedListPageState<JobsPage, JobModel, JobFilter, JobsDataNotifier> {
  @override
  get provider => jobsDataProvider;

  @override
  Widget buildListTile(JobModel item, int index) {
    return JobListItem(job: item, onTap: () => _open(item));
  }

  /// Jobs grouped like the booking page: by week ("this week", "next week", ...), then by day inside a rounded box.
  /// Keeps the order of [items], so the sort menu still decides which comes first.
  @override
  Widget? buildListLayout(BuildContext context, WidgetRef ref) {
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
  void _open(JobModel job) => context.push("/profile/jobs/${job.id}").then((_) => notifier.reload());

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
    ];
  }

  @override
  List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) {
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

  /// Only users who may create jobs get the add button.
  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    final user = ref.read(userDataProvider).user;
    if (user == null || !user.hasPermission(Permission.JOB_CREATE)) return null;
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => context.push("/profile/jobs/create").then((value) => value == true ? notifier.reload() : null),
    );
  }
}
