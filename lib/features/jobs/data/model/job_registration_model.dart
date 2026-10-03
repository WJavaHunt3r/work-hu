import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';

part 'job_registration_model.freezed.dart';
part 'job_registration_model.g.dart';

@freezed
abstract class JobRegistrationModel with _$JobRegistrationModel {
  const factory JobRegistrationModel({
    num? id,
    required num jobId,
    required num userId,
    String? userName,
    num? registeredById,
    String? registeredByName,

    /// Only sent to the registrant, their parent, the registrar and the people running the job.
    String? comment,
    required JobRegistrationStatus status,

    /// 1 = next to be promoted; only for waitlisted registrations.
    int? waitlistPosition,
    DateTime? registeredDateTime,
    DateTime? cancelledDateTime,
    @Default(0) double hours,
  }) = _JobRegistrationModel;

  factory JobRegistrationModel.fromJson(Map<String, dynamic> json) => _$JobRegistrationModelFromJson(json);

  const JobRegistrationModel._();

  bool get isWaitlisted => status == JobRegistrationStatus.WAITLISTED;

  bool get isRegistered => status == JobRegistrationStatus.REGISTERED;
}
