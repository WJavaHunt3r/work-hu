import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';

/// The round marker of a job, in theme colors: a check when the current user is registered, an hourglass on the
/// waitlist, otherwise a ring that fills up with the registrations, with the registered count inside.
///
/// [onFilled] is for markers drawn on a filled (primary colored) card.
class JobMarker extends StatelessWidget {
  const JobMarker({super.key, required this.job, this.onFilled = false, this.size});

  final JobModel job;
  final bool onFilled;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = this.size ?? 44.sp;
    final mine = job.myRegistrationStatus;
    if (mine == JobRegistrationStatus.REGISTERED || mine == JobRegistrationStatus.WAITLISTED) {
      final color = onFilled ? scheme.onPrimary : scheme.primary;
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(
          mine == JobRegistrationStatus.REGISTERED ? Icons.how_to_reg_outlined : Icons.hourglass_top,
          color: color,
          size: size * 0.5,
        ),
      );
    }
    final max = job.maxParticipants;
    final value = max == null ? (job.registeredCount > 0 ? 1.0 : 0.0) : (job.registeredCount / max).clamp(0.0, 1.0);
    // A full job turns red, so people see at a glance that there is no room left.
    final color = job.full && !job.waitlistEnabled ? scheme.error : scheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: value.toDouble(),
              strokeWidth: 2.5,
              color: color,
              backgroundColor: color.withValues(alpha: 0.25),
            ),
          ),
          Text(
            "${job.registeredCount}",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Small spaced-out uppercase heading, as used for the days in the list.
class SpacedHeader extends StatelessWidget {
  const SpacedHeader(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 2),
    );
  }
}
