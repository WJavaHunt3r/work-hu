import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/gender.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';

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
    required num employerId,
    required num responsibleId,
    required Account account,
    required TransactionType transactionType,
    required DateTime registrationDeadline,
    required DateTime cancellationDeadline,

    /// Number of places; null for unlimited.
    int? maxParticipants,
    @Default(false) bool waitlistEnabled,
    int? minAge,
    int? maxAge,

    /// Null means open to everyone.
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Gender? genderRestriction,

    // ---- read-only
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

  bool get isOpen => status == JobStatus.OPEN;

  /// "17:00 → 21:00", or just the start time when there is no end time.
  String get timeRange {
    final format = DateFormat("HH:mm");
    final start = format.format(jobDateTime);
    return jobEndDateTime == null ? start : "$start → ${format.format(jobEndDateTime!)}";
  }

  bool get hasStarted => !jobDateTime.isAfter(DateTime.now());

  /// Registrations beyond the limit go to the waitlist, if there is one.
  bool get canJoinWaitlist => full && waitlistEnabled;

  bool get hasAgeLimit => minAge != null || maxAge != null;
}
