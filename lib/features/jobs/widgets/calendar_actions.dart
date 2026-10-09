import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/data/repository/job_repository.dart';

/// Saves the job as an .ics file, which opens in (or imports into) the calendar of the user's choice.
Future<void> saveJobToCalendarFile(BuildContext context, JobRepository repository, JobModel job) async {
  try {
    final bytes = Uint8List.fromList(await repository.getIcs(job.id!));
    final name = "job-${job.id}";
    if (kIsWeb) {
      await FileSaver.instance.saveFile(name: name, bytes: bytes, fileExtension: 'ics', mimeType: MimeType.other);
    } else {
      await FileSaver.instance.saveAs(name: name, bytes: bytes, fileExtension: 'ics', mimeType: MimeType.other);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("jobs_calendar_saved".i18n())));
    }
  } on ApiException catch (e) {
    showApiError(e.message);
  } catch (_) {
    showApiError("api_unknown_error".i18n());
  }
}

/// Opens Google Calendar's "new event" page filled in with the job (a link that also works on phones, where the
/// calendar app opens it). Times are given with the time zone of the job, so they are right whatever the phone's zone.
Future<void> addJobToGoogleCalendar(JobModel job) async {
  String stamp(DateTime t) =>
      "${t.year.toString().padLeft(4, '0')}${t.month.toString().padLeft(2, '0')}${t.day.toString().padLeft(2, '0')}"
      "T${t.hour.toString().padLeft(2, '0')}${t.minute.toString().padLeft(2, '0')}00";
  final end = job.jobEndDateTime ?? job.jobDateTime.add(const Duration(hours: 2));
  final details = [
    if (job.comment != null && job.comment!.trim().isNotEmpty) job.comment!.trim(),
    if (job.employerName != null && job.employerName!.isNotEmpty) job.employerName!,
    job.shareUrl,
  ].join("\n\n");
  final uri = Uri.https("calendar.google.com", "/calendar/render", {
    "action": "TEMPLATE",
    "text": job.description,
    "dates": "${stamp(job.jobDateTime)}/${stamp(end)}",
    "ctz": "Europe/Budapest",
    "details": details,
  });
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// The user's subscription link: a calendar app that is given it shows their jobs and keeps them up to date.
Future<void> showCalendarSubscription(BuildContext context, JobRepository repository) => showDialog<void>(
  context: context,
  builder: (_) => _SubscribeDialog(repository: repository),
);

class _SubscribeDialog extends StatefulWidget {
  const _SubscribeDialog({required this.repository});

  final JobRepository repository;

  @override
  State<_SubscribeDialog> createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<_SubscribeDialog> {
  String? _url;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load(widget.repository.getCalendarToken);
  }

  Future<void> _load(Future<String> Function() getToken) async {
    try {
      final token = await getToken();
      if (mounted) setState(() => _url = widget.repository.calendarFeedUrl(token));
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = "api_unknown_error".i18n());
    }
  }

  Future<void> _reset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("jobs_calendar_reset".i18n()),
        content: Text("jobs_calendar_reset_question".i18n()),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text("base_cancel".i18n())),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text("jobs_calendar_reset".i18n()),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _url = null);
      await _load(widget.repository.resetCalendarToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = _url;
    return AlertDialog(
      title: Text("jobs_calendar_subscribe".i18n()),
      content: SizedBox(
        width: double.maxFinite,
        child: _error != null
            ? Text(_error!)
            : url == null
            ? const Center(heightFactor: 2, child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("jobs_calendar_subscribe_hint".i18n(), style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text("jobs_calendar_google_note".i18n(), style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),
                  SelectableText(url, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text(
                    "jobs_calendar_subscribe_secret".i18n(),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                ],
              ),
      ),
      actions: [
        if (url != null) ...[
          TextButton(onPressed: _reset, child: Text("jobs_calendar_reset".i18n())),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: url));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("jobs_calendar_link_copied".i18n())));
              }
            },
            child: Text("jobs_calendar_copy".i18n()),
          ),
          TextButton(
            // Google's own "add calendar" page; the Google Calendar app itself can't add a calendar from a link
            onPressed: () => launchUrl(
              Uri.https("calendar.google.com", "/calendar/render", {
                "cid": url.replaceFirst(RegExp(r'^https?://'), 'webcal://'),
              }),
              mode: LaunchMode.externalApplication,
            ),
            child: Text("jobs_calendar_google".i18n()),
          ),
          FilledButton(
            // webcal:// makes Apple, Outlook and most phones offer to subscribe
            onPressed: () => launchUrl(Uri.parse(url.replaceFirst(RegExp(r'^https?://'), 'webcal://'))),
            child: Text("jobs_calendar_open".i18n()),
          ),
        ] else
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("base_ok".i18n())),
      ],
    );
  }
}
