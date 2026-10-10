import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/locale_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_confirm_dialog.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';
import 'package:work_hu/features/jobs/data/model/job_hours_entry.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/data/model/job_registration_model.dart';
import 'package:work_hu/features/jobs/data/state/job_detail_state.dart';
import 'package:work_hu/features/jobs/providers/jobs_provider.dart';
import 'package:work_hu/features/jobs/view/jobs_page.dart';
import 'package:work_hu/features/jobs/widgets/calendar_actions.dart';
import 'package:work_hu/features/jobs/widgets/job_dialogs.dart';
import 'package:work_hu/features/jobs/widgets/job_marker.dart';
import 'package:work_hu/features/jobs/widgets/job_status_chip.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/utils.dart';

/// One job: its details and everyone who registered.
///
/// From the Jobs tab ([manage] false) it is for registering the current user and their children (plus "complete" for
/// the job's responsible person). From the admin list ([manage] true) it has the actions for the people running the
/// job instead: edit, cancel, complete with hours and register anyone.
class JobDetailPage extends BasePage {
  const JobDetailPage({super.key, required this.jobId, this.manage = false, super.title = "jobs_detail_title"});

  final num jobId;
  final bool manage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => JobDetailPageState();
}

class JobDetailPageState extends BasePageState<JobDetailPage, JobDetailState, JobDetailNotifier> {
  @override
  get provider => jobDetailProvider(widget.jobId);

  @override
  BaseState get status => state.status;

  JobDetailNotifier get notifier => ref.read(provider.notifier);

  UserModel get me => ref.read(userDataProvider).user!;

  /// JOB_MANAGE_ALL's extras (acting for anyone, cancelling after the deadline) belong to the admin view.
  bool get _manageAll => widget.manage && notifier.canManageAll;

  @override
  void onRefresh() => notifier.load();

  // ---------------------------------------------------------------- actions

  @override
  List<Widget>? buildActions(BuildContext context, WidgetRef ref) {
    final job = state.job;
    if (job == null) return [];
    return [
      PopupMenuButton<String>(
        icon: const Icon(Icons.event_available_outlined),
        tooltip: "jobs_add_to_calendar".i18n(),
        onSelected: (choice) => choice == "google"
            ? addJobToGoogleCalendar(job)
            : saveJobToCalendarFile(context, ref.read(jobRepoProvider), job),
        itemBuilder: (_) => [
          PopupMenuItem(value: "google", child: Text("jobs_calendar_google_event".i18n())),
          PopupMenuItem(value: "file", child: Text("jobs_calendar_file".i18n())),
        ],
      ),
      IconButton(icon: const Icon(Icons.share_outlined), tooltip: "jobs_share".i18n(), onPressed: () => _share(job)),
      if (widget.manage && job.isOpen && notifier.canEdit)
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: "jobs_edit".i18n(),
          onPressed: () => context.push("${JobsPage.basePath(true)}/${job.id}/edit").then((_) => notifier.load()),
        ),
      if (widget.manage && job.isOpen && notifier.canEdit)
        IconButton(
          icon: const Icon(Icons.cancel_outlined),
          tooltip: "jobs_cancel_job".i18n(),
          onPressed: _confirmCancelJob,
        ),
      if (widget.manage && job.isOpen && notifier.canEdit && job.isRepeating)
        IconButton(
          icon: const Icon(Icons.event_busy_outlined),
          tooltip: "jobs_cancel_series".i18n(),
          onPressed: () => _confirmCancelSeries(job.seriesId!),
        ),
    ];
  }

  /// The chat is for the people taking part (registered, responsible, creator) and for those who manage all jobs.
  bool _canOpenChat(JobModel job) =>
      job.chatAccess == true ||
      job.myRegistrationStatus == JobRegistrationStatus.REGISTERED ||
      job.responsibleId == me.id ||
      job.createUserId == me.id ||
      notifier.canManageAll;

  /// Copies the link that opens this job (after signing in) so it can be pasted into a chat or message.
  Future<void> _share(JobModel job) async {
    await Clipboard.setData(ClipboardData(text: "${job.description}\n${job.shareUrl}"));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("jobs_share_copied".i18n())));
  }

  void _confirmCancelJob() {
    showDialog<bool>(
      context: context,
      builder: (_) =>
          BaseConfirmDialog(title: "jobs_cancel_job", content: "jobs_cancel_job_question", onConfirm: () {}),
    ).then((confirmed) => confirmed == true ? notifier.cancelJob() : null);
  }

  void _confirmCancelSeries(String seriesId) {
    showDialog<bool>(
      context: context,
      builder: (_) =>
          BaseConfirmDialog(title: "jobs_cancel_series", content: "jobs_cancel_series_question", onConfirm: () {}),
    ).then((confirmed) => confirmed == true ? notifier.cancelSeries(seriesId) : null);
  }

  Future<void> _register(JobModel job, {required num userId}) async {
    final comment = await showCommentDialog(
      context,
      title: job.canJoinWaitlist ? "jobs_join_waitlist" : "jobs_register",
    );
    if (comment == null) return;
    await notifier.register(userId: userId == me.id ? null : userId, comment: comment.isEmpty ? null : comment);
  }

  Future<void> _editComment(JobRegistrationModel registration) async {
    final comment = await showCommentDialog(context, title: "jobs_edit_comment", initial: registration.comment);
    if (comment == null) return;
    await notifier.updateComment(userId: registration.userId == me.id ? null : registration.userId, comment: comment);
  }

  void _confirmCancelRegistration(JobRegistrationModel registration) {
    showDialog<bool>(
      context: context,
      builder: (_) => BaseConfirmDialog(
        title: "jobs_cancel_registration",
        content: "jobs_cancel_registration_question",
        onConfirm: () {},
      ),
    ).then(
      (confirmed) => confirmed == true
          ? notifier.cancelRegistration(userId: registration.userId == me.id ? null : registration.userId)
          : null,
    );
  }

  Future<void> _registerSomeone(JobModel job) async {
    final result = await showDialog<({UserComboModel user, String? comment})>(
      context: context,
      builder: (_) => const JobRegisterSomeoneDialog(),
    );
    if (result == null) return;
    await notifier.register(userId: result.user.id, comment: result.comment);
  }

  Future<void> _complete(JobModel job) async {
    final entries = await showDialog<List<JobHoursEntry>>(
      context: context,
      builder: (_) => JobCompleteDialog(
        registrations: state.registrations.where((r) => r.isRegistered).toList(),
        defaultHours: job.defaultHours,
      ),
    );
    if (entries == null) return;
    final activity = await notifier.complete(entries);
    if (activity != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("jobs_completed_message".i18n())));
    }
  }

  // ---------------------------------------------------------------- layout

  @override
  Widget buildLayout() {
    final job = state.job;
    if (job == null) {
      return status.modelState.isAnyLoading
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 32.sp),
              child: const Center(child: CircularProgressIndicator.adaptive()),
            )
          : const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(job),
        SizedBox(height: 16.sp),
        _buildOrganizerActions(job),
        _buildDetails(job),
        SizedBox(height: 12.sp),
        if (!widget.manage) ...[_buildMyRegistrations(job), SizedBox(height: 12.sp)],
        _buildRegistrations(job),
        SizedBox(height: 32.sp),
      ],
    );
  }

  /// Day, title and time range with the round marker, like a card of the list but bigger.
  Widget _buildHeader(JobModel job) {
    final theme = Theme.of(context);
    final locale = ref.read(localeProvider).value?.languageCode;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacedHeader(DateFormat("EEEE · dd. MMMM", locale).format(job.jobDateTime)),
              SizedBox(height: 8.sp),
              Text(job.description, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              if (job.comment != null && job.comment!.trim().isNotEmpty) ...[
                SizedBox(height: 8.sp),
                SelectableText(job.comment!, style: theme.textTheme.bodyMedium),
              ],
              SizedBox(height: 4.sp),
              Text(
                [job.timeRange, if (job.employerName != null) job.employerName!].join("  ·  "),
                style: theme.textTheme.titleMedium?.copyWith(color: theme.hintColor),
              ),
              if (!job.isOpen) ...[SizedBox(height: 8.sp), StatusLabel.job(context, job.status)],
            ],
          ),
        ),
        SizedBox(width: 12.sp),
        JobMarker(job: job, size: 52.sp),
      ],
    );
  }

  /// A rounded box like the day boxes of the list.
  Widget _box({required String? header, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[SpacedHeader(header), SizedBox(height: 12.sp)],
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetails(JobModel job) {
    final places = job.maxParticipants == null
        ? "${job.registeredCount}  (${"jobs_unlimited".i18n()})"
        : "${job.registeredCount}/${job.maxParticipants}";
    return _box(
      header: null,
      children: [
        _InfoRow("jobs_responsible", job.responsibleName ?? ""),
        if (job.registrationOpensAt != null)
          _InfoRow("jobs_registration_opens", Utils.dateToStringWithTime(job.registrationOpensAt!)),
        if (job.registrationClosed) _InfoRow("jobs_registration_start", "jobs_reg_start_closed".i18n()),
        _InfoRow(
          "jobs_registration_deadline",
          job.registrationDeadline == null
              ? "jobs_no_deadline".i18n()
              : Utils.dateToStringWithTime(job.registrationDeadline!),
        ),
        _InfoRow(
          "jobs_cancellation_deadline",
          !job.cancellationAllowed
              ? "jobs_cancel_not_allowed".i18n()
              : job.cancellationDeadline == null
              ? "jobs_no_deadline".i18n()
              : Utils.dateToStringWithTime(job.cancellationDeadline!),
        ),
        _InfoRow("jobs_places", places),
        if (job.waitlistEnabled) _InfoRow("jobs_waitlist", "${job.waitlistCount}"),
        if (job.hasAgeLimit) _InfoRow("jobs_age", "${job.minAge ?? "-"} - ${job.maxAge ?? "-"}"),
        if (job.genderRestriction != null) _InfoRow("jobs_gender", job.genderRestriction!.label.i18n()),
        if (job.createUserName != null) _InfoRow("jobs_created_by", job.createUserName!),
        if (_canOpenChat(job))
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.forum_outlined),
            title: Text("jobs_chat_title".i18n()),
            subtitle: job.isOpen ? null : Text("jobs_chat_archived_short".i18n()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push("${JobsPage.basePath(widget.manage)}/${job.id}/chat"),
          ),
        if (job.isRepeating) _InfoRow("jobs_repeating", "jobs_repeating_value".i18n()),
        if (job.status == JobStatus.COMPLETED && job.activityId != null) ...[
          SizedBox(height: 8.sp),
          OutlinedButton.icon(
            onPressed: () => context.push("/profile/activities/${job.activityId}/items"),
            icon: const Icon(Icons.list_alt),
            label: Text("jobs_view_activity".i18n()),
          ),
        ],
      ],
    );
  }

  /// In the admin view: complete and register anyone. In the tab only the responsible person gets "complete", since
  /// they may not have access to the admin.
  Widget _buildOrganizerActions(JobModel job) {
    if (!job.isOpen) return const SizedBox();
    final canComplete = widget.manage ? notifier.canComplete : job.responsibleId == me.id;
    // Registering anyone is for JOB_MANAGE_ALL, in the Jobs tab as well as in the admin list.
    final canRegisterSomeone = notifier.canManageAll;
    if (!canComplete && !canRegisterSomeone) return const SizedBox();
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Wrap(
        spacing: 8.sp,
        runSpacing: 8.sp,
        children: [
          if (canComplete)
            FilledButton.icon(
              onPressed: job.hasStarted ? () => _complete(job) : null,
              icon: const Icon(Icons.task_alt),
              label: Text(job.hasStarted ? "jobs_complete".i18n() : "jobs_complete_after_start".i18n()),
            ),
          if (canRegisterSomeone)
            OutlinedButton.icon(
              onPressed: () => _registerSomeone(job),
              icon: const Icon(Icons.person_add_alt),
              label: Text("jobs_register_someone".i18n()),
            ),
        ],
      ),
    );
  }

  /// The current user, their spouse and children, one card each, in the style of the list: filled when registered.
  Widget _buildMyRegistrations(JobModel job) {
    final people = <({num id, String name})>[
      (id: me.id, name: me.getFullName()),
      for (final child in state.children) (id: child.id, name: child.getFullName()),
    ];
    return _box(
      header: "jobs_my_registration_header".i18n(),
      children: [for (final person in people) _buildPerson(job, person.id, person.name)],
    );
  }

  Widget _buildPerson(JobModel job, num userId, String name) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final registration = state.registrationOf(userId);
    final registered = registration?.isRegistered ?? false;
    final foreground = registered ? scheme.onPrimary : scheme.onSurface;
    final secondary = registered ? scheme.onPrimary.withValues(alpha: 0.8) : theme.hintColor;

    String? hint;
    Widget? trailing;
    final actions = <Widget>[];
    if (registration != null) {
      hint = registration.isWaitlisted
          ? "${"jobs_registration_waitlisted".i18n()} #${registration.waitlistPosition ?? "-"}"
          : "jobs_registration_registered".i18n();
      if (job.isOpen) {
        actions.add(
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: foreground),
            onPressed: () => _editComment(registration),
            icon: const Icon(Icons.comment_outlined, size: 18),
            label: Text("jobs_edit_comment".i18n()),
          ),
        );
        if (job.cancellationOpen || _manageAll) {
          actions.add(
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: registered ? foreground : scheme.error),
              onPressed: () => _confirmCancelRegistration(registration),
              icon: const Icon(Icons.person_remove_outlined, size: 18),
              label: Text("jobs_cancel_registration".i18n()),
            ),
          );
        }
      }
      trailing = Container(
        width: 44.sp,
        height: 44.sp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: registered ? scheme.onPrimary : scheme.primary, width: 2),
        ),
        child: Icon(
          registered ? Icons.how_to_reg_outlined : Icons.hourglass_top,
          color: registered ? scheme.onPrimary : scheme.primary,
          size: 22.sp,
        ),
      );
    } else if (job.isOpen && job.registrationOpen && (!job.full || job.waitlistEnabled)) {
      trailing = FilledButton(
        onPressed: () => _register(job, userId: userId),
        child: Text((job.canJoinWaitlist ? "jobs_join_waitlist" : "jobs_register").i18n()),
      );
    } else {
      hint = job.isOpen && job.registrationNotOpenYet
          ? "jobs_registration_opens_on".i18n([Utils.dateToStringWithTime(job.registrationOpensAt!)])
          : (job.isOpen
                    ? (job.full && !job.waitlistEnabled ? "jobs_full" : "jobs_registration_closed")
                    : "jobs_not_registered")
                .i18n();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Material(
        color: registered ? scheme.primary : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.sp),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: foreground),
                        ),
                        if (hint != null) Text(hint, style: theme.textTheme.bodyMedium?.copyWith(color: secondary)),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[SizedBox(width: 8.sp), trailing],
                ],
              ),
              if (actions.isNotEmpty) Wrap(spacing: 4.sp, children: actions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrations(JobModel job) {
    final theme = Theme.of(context);
    final registered = state.registrations.where((r) => r.isRegistered).toList();
    final waitlisted = state.registrations.where((r) => r.isWaitlisted).toList();
    return _box(
      header: "${"jobs_registrations".i18n()} · ${registered.length}",
      children: [
        if (registered.isEmpty) Text("jobs_no_registrations".i18n(), style: theme.textTheme.bodySmall),
        for (final r in registered) _buildRegistrationTile(job, r),
        if (waitlisted.isNotEmpty) ...[
          SizedBox(height: 16.sp),
          SpacedHeader("${"jobs_waitlist".i18n()} · ${waitlisted.length}"),
          SizedBox(height: 8.sp),
          for (final r in waitlisted) _buildRegistrationTile(job, r),
        ],
      ],
    );
  }

  Widget _buildRegistrationTile(JobModel job, JobRegistrationModel r) {
    final theme = Theme.of(context);
    final mayAct = widget.manage
        ? notifier.canActFor(r.userId)
        : r.userId == me.id || state.children.any((c) => c.id == r.userId);
    final canCancel = job.isOpen && mayAct && (job.cancellationOpen || _manageAll);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(r.userName ?? "${r.userId}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (r.comment != null && r.comment!.isNotEmpty) Text(r.comment!, style: theme.textTheme.bodySmall),
          if (r.registeredById != null && r.registeredById != r.userId && r.registeredByName != null)
            Text(
              "${"jobs_registered_by".i18n()}: ${r.registeredByName}",
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          if (job.status == JobStatus.COMPLETED && r.isRegistered)
            Text("${r.hours} ${"base_text_hours_short".i18n()}", style: theme.textTheme.bodySmall),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (r.isWaitlisted) StatusLabel.registration(context, r.status, waitlistPosition: r.waitlistPosition),
          if (canCancel)
            IconButton(
              icon: Icon(Icons.close, color: theme.colorScheme.error),
              onPressed: () => _confirmCancelRegistration(r),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.labelKey, this.value);

  final String labelKey;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130.sp,
            child: Text(labelKey.i18n(), style: theme.textTheme.bodySmall),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
