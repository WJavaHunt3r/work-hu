import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/providers/locale_provider.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';
import 'package:work_hu/features/jobs/data/model/job_filter.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/providers/jobs_provider.dart';
import 'package:work_hu/features/jobs/view/jobs_page.dart';
import 'package:work_hu/features/jobs/widgets/calendar_actions.dart';
import 'package:work_hu/features/jobs/widgets/job_list_item.dart';
import 'package:work_hu/app/platform/adaptive.dart';

enum _Mode { week, month }

/// The jobs of a week or a month, with the choice of importing them into the user's own calendar (a subscription link
/// for the jobs they are registered for). The Jobs tab shows open jobs; the admin list ([manage]) shows every status.
class JobsCalendarPage extends ConsumerStatefulWidget {
  const JobsCalendarPage({super.key, this.manage = false});

  final bool manage;

  @override
  ConsumerState<JobsCalendarPage> createState() => _JobsCalendarPageState();
}

class _JobsCalendarPageState extends ConsumerState<JobsCalendarPage> {
  /// Enough for a month; a calendar needs everything of the period at once, not a page of it.
  static const _maxJobs = 300;

  _Mode _mode = _Mode.week;
  late DateTime _anchor = _day(DateTime.now());
  late DateTime _selected = _day(DateTime.now());
  List<JobModel> _jobs = [];
  bool _loading = true;

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime _monday(DateTime d) => _day(DateTime(d.year, d.month, d.day - (d.weekday - 1)));

  String? get _locale => ref.read(localeProvider).value?.languageCode;

  /// The first and last day shown: a week, or the weeks of the month (full weeks, so the grid has no gaps).
  (DateTime, DateTime) get _range {
    if (_mode == _Mode.week) {
      final start = _monday(_anchor);
      return (start, DateTime(start.year, start.month, start.day + 6));
    }
    final first = DateTime(_anchor.year, _anchor.month, 1);
    final last = DateTime(_anchor.year, _anchor.month + 1, 0);
    final start = _monday(first);
    return (start, DateTime(last.year, last.month, last.day + (7 - last.weekday)));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final (from, to) = _range;
    try {
      final result = await ref
          .read(jobRepoProvider)
          .getJobs(
            ListQuery<JobFilter>(
              filter: JobFilter(dateFrom: from, dateTo: to, status: widget.manage ? null : JobStatus.OPEN),
              size: _maxJobs,
            ),
          );
      if (mounted) setState(() => _jobs = result.content);
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _move(int direction) {
    setState(() {
      _anchor = _mode == _Mode.week
          ? DateTime(_anchor.year, _anchor.month, _anchor.day + 7 * direction)
          : DateTime(_anchor.year, _anchor.month + direction, 1);
      // The selected day of the month view follows into the new month
      if (_mode == _Mode.month) _selected = _anchor;
    });
    _load();
  }

  void _today() {
    setState(() {
      _anchor = _day(DateTime.now());
      _selected = _anchor;
    });
    _load();
  }

  List<JobModel> _jobsOn(DateTime day) =>
      _jobs.where((j) => _day(j.jobDateTime) == day).toList()..sort((a, b) => a.jobDateTime.compareTo(b.jobDateTime));

  String get _title {
    final (from, to) = _range;
    if (_mode == _Mode.month) return _capital(DateFormat("yyyy. MMMM", _locale).format(_anchor));
    final sameMonth = from.month == to.month;
    return "${DateFormat("MMM d", _locale).format(from)} – ${DateFormat(sameMonth ? "d" : "MMM d", _locale).format(to)}";
  }

  String _capital(String text) => text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

  void _open(JobModel job) => context.push("${JobsPage.basePath(widget.manage)}/${job.id}").then((_) => _load());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("jobs_calendar_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_calendar_outlined),
            tooltip: "jobs_calendar_subscribe".i18n(),
            onPressed: () => showCalendarSubscription(context, ref.read(jobRepoProvider)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 0),
            child: AdaptiveSegmented<_Mode>(
              options: {_Mode.week: "jobs_calendar_week".i18n(), _Mode.month: "jobs_calendar_month".i18n()},
              selected: _mode,
              onChanged: (mode) {
                if (mode == null) return;
                setState(() => _mode = mode);
                _load();
              },
            ),
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _move(-1)),
              Expanded(
                child: Center(
                  child: Text(_title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              TextButton(onPressed: _today, child: Text("jobs_calendar_today".i18n())),
              IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _move(1)),
            ],
          ),
          if (_loading) const LinearProgressIndicator(),
          Expanded(child: _mode == _Mode.week ? _buildWeek(theme) : _buildMonth(theme)),
        ],
      ),
    );
  }

  Widget _buildWeek(ThemeData theme) {
    final start = _monday(_anchor);
    final today = _day(DateTime.now());
    return ListView(
      padding: EdgeInsets.all(16.sp),
      children: [
        for (var i = 0; i < 7; i++) ...[
          Builder(
            builder: (context) {
              final day = DateTime(start.year, start.month, start.day + i);
              final jobs = _jobsOn(day);
              final isToday = day == today;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.sp, bottom: 6.sp),
                    child: Text(
                      _capital(DateFormat("EEEE · MMM d", _locale).format(day)),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isToday ? theme.colorScheme.primary : null,
                      ),
                    ),
                  ),
                  if (jobs.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.sp),
                      child: Text(
                        "jobs_calendar_no_jobs".i18n(),
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                    )
                  else
                    for (final job in jobs) JobListItem(job: job, onTap: () => _open(job)),
                ],
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildMonth(ThemeData theme) {
    final (from, to) = _range;
    final weeks = (to.difference(from).inDays + 1) ~/ 7;
    final today = _day(DateTime.now());
    final selectedJobs = _jobsOn(_selected);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      children: [
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat("E", _locale).format(DateTime(2024, 1, 1 + i)),
                    style: theme.textTheme.labelMedium?.copyWith(color: theme.hintColor),
                  ),
                ),
              ),
          ],
        ),
        for (var w = 0; w < weeks; w++)
          Row(
            children: [
              for (var d = 0; d < 7; d++)
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final day = DateTime(from.year, from.month, from.day + w * 7 + d);
                      return _DayCell(
                        day: day,
                        inMonth: day.month == _anchor.month,
                        isToday: day == today,
                        selected: day == _selected,
                        count: _jobsOn(day).length,
                        onTap: () => setState(() => _selected = day),
                      );
                    },
                  ),
                ),
            ],
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(8.sp, 16.sp, 8.sp, 8.sp),
          child: Text(
            _capital(DateFormat("EEEE · MMM d", _locale).format(_selected)),
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        if (selectedJobs.isEmpty)
          Padding(
            padding: EdgeInsets.all(8.sp),
            child: Text(
              "jobs_calendar_no_jobs".i18n(),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          )
        else
          for (final job in selectedJobs)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
              child: JobListItem(job: job, onTap: () => _open(job)),
            ),
        SizedBox(height: 24.sp),
      ],
    );
  }
}

/// One day of the month grid: its number and one dot per job (three at most, then a plus).
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.isToday,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  final DateTime day;
  final bool inMonth;
  final bool isToday;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.sp),
      child: Container(
        height: 52.sp,
        margin: EdgeInsets.all(2.sp),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : null,
          border: isToday ? Border.all(color: scheme.primary) : null,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${day.day}",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isToday || selected ? FontWeight.bold : null,
                color: inMonth ? null : theme.hintColor.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 4.sp),
            SizedBox(
              height: 8.sp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < (count > 3 ? 3 : count); i++)
                    Container(
                      width: 6.sp,
                      height: 6.sp,
                      margin: EdgeInsets.symmetric(horizontal: 1.sp),
                      decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
                    ),
                  if (count > 3) Text("+", style: theme.textTheme.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
