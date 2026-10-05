import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/data/model/job_registration_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'job_detail_state.freezed.dart';

@freezed
abstract class JobDetailState with _$JobDetailState {
  const factory JobDetailState({
    JobModel? job,

    /// Active registrations (registered and waitlisted) in registration order.
    @Default([]) List<JobRegistrationModel> registrations,

    /// The people the current user may register and cancel besides themselves: their spouse and their children.
    @Default([]) List<UserModel> children,
    @Default(BaseState()) BaseState status,
  }) = _JobDetailState;

  const JobDetailState._();

  JobRegistrationModel? registrationOf(num userId) {
    for (final r in registrations) {
      if (r.userId == userId) return r;
    }
    return null;
  }
}
