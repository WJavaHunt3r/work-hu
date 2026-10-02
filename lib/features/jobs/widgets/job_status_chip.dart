import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';

/// Small coloured label for the state of a job or of a registration.
class StatusLabel extends StatelessWidget {
  const StatusLabel({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  factory StatusLabel.job(BuildContext context, JobStatus status) {
    final scheme = Theme.of(context).colorScheme;
    return StatusLabel(
      text: status.label.i18n(),
      color: switch (status) {
        JobStatus.OPEN => scheme.primary,
        JobStatus.COMPLETED => Colors.green,
        JobStatus.CANCELLED => scheme.error,
      },
    );
  }

  factory StatusLabel.registration(BuildContext context, JobRegistrationStatus status, {int? waitlistPosition}) {
    final scheme = Theme.of(context).colorScheme;
    final base = status.label.i18n();
    return StatusLabel(
      text: status == JobRegistrationStatus.WAITLISTED && waitlistPosition != null ? "$base #$waitlistPosition" : base,
      color: switch (status) {
        JobRegistrationStatus.REGISTERED => Colors.green,
        JobRegistrationStatus.WAITLISTED => Colors.orange,
        JobRegistrationStatus.CANCELLED => scheme.error,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 2.sp),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
