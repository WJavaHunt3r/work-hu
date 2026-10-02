import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/jobs/data/api/job_api.dart';
import 'package:work_hu/features/jobs/data/model/job_filter.dart';
import 'package:work_hu/features/jobs/data/model/job_hours_entry.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/data/model/job_registration_model.dart';

/// Every call goes through [guardApi], so rule violations (full, deadline passed, not eligible, ...) reach the UI
/// as an [ApiException] carrying the backend's message.
class JobRepository {
  JobRepository(this._api);

  final JobApi _api;

  Future<PaginatedResponse<JobModel>> getJobs(ListQuery<JobFilter> query, {int page = 0, num? registeredUserId}) =>
      guardApi(() async {
        final res = await _api.getJobs(query, page, registeredUserId: registeredUserId);
        return PaginatedResponse<JobModel>.fromJson(res, (json) => JobModel.fromJson(json as Map<String, dynamic>));
      });

  Future<JobModel> getJob(num jobId) => guardApi(() async => JobModel.fromJson(await _api.getJob(jobId)));

  Future<JobModel> saveJob(JobModel job) =>
      guardApi(() async => JobModel.fromJson(job.id == null ? await _api.postJob(job) : await _api.putJob(job)));

  Future<JobModel> cancelJob(num jobId) => guardApi(() async => JobModel.fromJson(await _api.cancelJob(jobId)));

  Future<List<JobRegistrationModel>> getRegistrations(num jobId) => guardApi(() async {
    final res = await _api.getRegistrations(jobId);
    return res.map((e) => JobRegistrationModel.fromJson(e as Map<String, dynamic>)).toList();
  });

  Future<JobRegistrationModel> register(num jobId, {num? userId, String? comment}) =>
      guardApi(() async => JobRegistrationModel.fromJson(await _api.register(jobId, userId: userId, comment: comment)));

  Future<JobRegistrationModel> updateRegistration(num jobId, {num? userId, String? comment}) => guardApi(
    () async => JobRegistrationModel.fromJson(await _api.updateRegistration(jobId, userId: userId, comment: comment)),
  );

  Future<JobRegistrationModel> cancelRegistration(num jobId, {num? userId}) =>
      guardApi(() async => JobRegistrationModel.fromJson(await _api.cancelRegistration(jobId, userId: userId)));

  Future<ActivityModel> completeJob(num jobId, List<JobHoursEntry> entries) =>
      guardApi(() async => ActivityModel.fromJson(await _api.completeJob(jobId, entries)));
}
