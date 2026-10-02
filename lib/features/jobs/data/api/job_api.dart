import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/jobs/data/model/job_filter.dart';
import 'package:work_hu/features/jobs/data/model/job_hours_entry.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/utils.dart';

class JobApi {
  final DioClient _dioClient = locator<DioClient>();

  /// [registeredUserId] is resolved by the caller from `JobFilter.onlyMine`.
  Future<dynamic> getJobs(ListQuery<JobFilter> query, int page, {num? registeredUserId}) async {
    final filter = query.filter;
    final search = filter.searchText?.trim();
    final res = await _dioClient.dio.get(
      "/job",
      queryParameters: {
        "status": filter.status?.name,
        "openOnly": filter.openOnly,
        "registeredUserId": registeredUserId,
        "dateFrom": filter.dateFrom == null ? null : Utils.dateToString(filter.dateFrom!),
        "dateTo": filter.dateTo == null ? null : Utils.dateToString(filter.dateTo!),
        "searchText": search == null || search.isEmpty ? null : search,
        ...query.pageParams(page),
      },
    );
    return res.data;
  }

  Future<dynamic> getJob(num jobId) async => (await _dioClient.dio.get("/job/$jobId")).data;

  Future<dynamic> postJob(JobModel job) async => (await _dioClient.dio.post("/job", data: job.toJson())).data;

  Future<dynamic> putJob(JobModel job) async => (await _dioClient.dio.put("/job/${job.id}", data: job.toJson())).data;

  Future<dynamic> cancelJob(num jobId) async => (await _dioClient.dio.post("/job/$jobId/cancel")).data;

  Future<List<dynamic>> getRegistrations(num jobId) async =>
      (await _dioClient.dio.get("/job/$jobId/registrations")).data;

  /// Registers [userId] (null = the current user; their child, or anyone with JOB_MANAGE_ALL).
  Future<dynamic> register(num jobId, {num? userId, String? comment}) async =>
      (await _dioClient.dio.post("/job/$jobId/register", data: {"userId": userId, "comment": comment})).data;

  Future<dynamic> updateRegistration(num jobId, {num? userId, String? comment}) async =>
      (await _dioClient.dio.put("/job/$jobId/register", data: {"userId": userId, "comment": comment})).data;

  Future<dynamic> cancelRegistration(num jobId, {num? userId}) async =>
      (await _dioClient.dio.delete("/job/$jobId/register", queryParameters: {"userId": userId})).data;

  /// Submits the hours and closes the job; returns the created activity.
  Future<dynamic> completeJob(num jobId, List<JobHoursEntry> entries) async => (await _dioClient.dio.post(
    "/job/$jobId/complete",
    data: {"items": entries.map((e) => e.toJson()).toList()},
  )).data;
}
