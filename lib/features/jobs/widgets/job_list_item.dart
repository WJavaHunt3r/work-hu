import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/widgets/job_marker.dart';

/// One job as a card, in the style of the booking page people already know: title, time range and a round marker on
/// the right (see [JobMarker]). A job the current user is registered for is a filled card.
class JobListItem extends StatelessWidget {
  const JobListItem({super.key, required this.job, required this.onTap});

  final JobModel job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final registered = job.myRegistrationStatus == JobRegistrationStatus.REGISTERED;
    final inactive = job.status != JobStatus.OPEN;
    final foreground = registered ? scheme.onPrimary : scheme.onSurface;
    final secondary = registered ? scheme.onPrimary.withValues(alpha: 0.8) : theme.hintColor;
    final subtitle = [
      job.timeRange,
      if (job.employerName != null && job.employerName!.isNotEmpty) job.employerName!,
    ].join("  ·  ");

    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Opacity(
        opacity: inactive ? 0.6 : 1,
        child: Material(
          color: registered ? scheme.primary : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.sp),
            side: BorderSide(color: scheme.outlineVariant),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8.sp),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 14.sp),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: foreground),
                        ),
                        SizedBox(height: 4.sp),
                        Text(
                          subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
                        ),
                        if (job.status != JobStatus.OPEN)
                          Padding(
                            padding: EdgeInsets.only(top: 2.sp),
                            child: Text(
                              job.status.label.i18n(),
                              style: theme.textTheme.bodySmall?.copyWith(color: secondary),
                            ),
                          )
                        else if (job.full && !job.waitlistEnabled && !registered)
                          Padding(
                            padding: EdgeInsets.only(top: 2.sp),
                            child: Text(
                              "jobs_full".i18n(),
                              style: theme.textTheme.bodySmall?.copyWith(color: scheme.error),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.sp),
                  JobMarker(job: job, onFilled: registered),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
