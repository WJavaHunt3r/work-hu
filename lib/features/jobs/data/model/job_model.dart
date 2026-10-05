import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/gender.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';
import 'package:work_hu/features/utils.dart';

import 'package:work_hu/features/jobs/data/model/job_recurrence_model.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

/// A job people register for before it happens. Completing it creates a normal activity (see [activityId]).
///
/// On create/update the backend only reads the input fields; everything under "read-only" is filled by the server.
@freezed
abstract class JobModel with _$JobModel {
  const factory JobModel({
    num? id,

    // ---- input
    required DateTime jobDateTime,

    /// When the job ends; null for jobs created without an end time.
    DateTime? jobEndDateTime,
    required String description,

    /// Longer free text from the creator (details, what to bring, ...).
    String? comment,
    required num employerId,
    required num responsibleId,
    required Account account,
    required TransactionType transactionType,

    /// Registration opens at this time; null means it is open from the start.
    DateTime? registrationOpensAt,

    /// Send a "new job" push when registration opens.
    @Default(true) bool sendNotification,

    /// Last moment to register; null = no deadline.
    DateTime? registrationDeadline,

    /// Registered users can cancel on their own until then; null = no deadline.
    DateTime? cancellationDeadline,

    /// False: registered users can't cancel on their own at all.
    @Default(true) bool cancellationAllowed,

    /// True: nobody can register until the job is opened again.
    @Default(false) bool registrationClosed,

    /// Number of places; null for unlimited.
    int? maxParticipants,
    @Default(false) bool waitlistEnabled,
    int? minAge,
    int? maxAge,

    /// Null means open to everyone.
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Gender? genderRestriction,

    /// Only sent when creating: repeats the job on the given weekdays until a date.
    @JsonKey(includeIfNull: false) JobRecurrenceModel? recurrence,

    // ---- read-only

    /// Shared by the occurrences of a repeating job; null for a single job.
    String? seriesId,
    DateTime? createDateTime,
    num? createUserId,
    String? createUserName,
    String? employerName,
    String? responsibleName,
    @Default(JobStatus.OPEN) JobStatus status,

    /// The activity created when the job was completed.
    num? activityId,
    DateTime? completedDateTime,
    @Default(0) num registeredCount,
    @Default(0) num waitlistCount,
    @Default(false) bool full,

    /// Open for new registrations (or the waitlist) right now.
    @Default(false) bool registrationOpen,

    /// Registered users can still cancel on their own.
    @Default(false) bool cancellationOpen,

    /// The requesting user's own registration; null if none.
    JobRegistrationStatus? myRegistrationStatus,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);

  const JobModel._();

  /// Registration is scheduled for later.
  bool get registrationNotOpenYet => registrationOpensAt != null && registrationOpensAt!.isAfter(DateTime.now());

  /// Opens this job in the app (after sign-in), also for people who tap it outside the app.
  String get shareUrl => Utils.appUrl("/profile/jobs/$id");

  bool get isOpen => status == JobStatus.OPEN;

  /// "17:00 → 21:00", or just the start time when there is no end time.
  String get timeRange {
    final format = DateFormat("HH:mm");
    final start = format.format(jobDateTime);
    return jobEndDateTime == null ? start : "$start → ${format.format(jobEndDateTime!)}";
  }

  /// Hours to suggest when completing: as long as the job was planned, at least 1 and at most 8.
  /// Jobs without an end time suggest the minimum.
  double get defaultHours {
    if (jobEndDateTime == null) return 1;
    final hours = jobEndDateTime!.difference(jobDateTime).inMinutes / 60;
    return (hours.clamp(1, 8) * 100).round() / 100;
  }

  bool get hasStarted => !jobDateTime.isAfter(DateTime.now());

  /// Registrations beyond the limit go to the waitlist, if there is one.
  bool get canJoinWaitlist => full && waitlistEnabled;

  bool get isRepeating => seriesId != null;

  bool get hasAgeLimit => minAge != null || maxAge != null;
}
