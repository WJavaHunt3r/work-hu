import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/jobs/data/api/job_api.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';
import 'package:work_hu/features/jobs/data/model/job_filter.dart';
import 'package:work_hu/features/jobs/data/model/job_hours_entry.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/data/model/job_registration_model.dart';
import 'package:work_hu/features/jobs/data/repository/job_repository.dart';
import 'package:work_hu/features/jobs/data/state/job_detail_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final jobApiProvider = Provider<JobApi>((ref) => JobApi());

final jobRepoProvider = Provider<JobRepository>((ref) => JobRepository(ref.read(jobApiProvider)));

/// The job list, by mode: `false` is the registration list of the Jobs tab, `true` the admin list. Separate instances,
/// because the tab stays alive while the admin list is open and the two must not share their filters.
final jobsDataProvider = StateNotifierProvider.autoDispose
    .family<JobsDataNotifier, PagedState<JobModel, JobFilter>, bool>(
      (ref, manage) => JobsDataNotifier(ref.read(jobRepoProvider), ref.read(userDataProvider).user),
    );

/// One job with its registrations, by job id.
final jobDetailProvider = StateNotifierProvider.autoDispose.family<JobDetailNotifier, JobDetailState, num>(
  (ref, jobId) =>
      JobDetailNotifier(ref.read(jobRepoProvider), ref.read(usersRepoProvider), ref.read(userDataProvider).user, jobId),
);

class JobsDataNotifier extends PagedListNotifier<JobModel, JobFilter> {
  JobsDataNotifier(this.jobRepository, this.user)
    : super(
        ListQuery(
          filter: const JobFilter(status: JobStatus.OPEN),
          sort: const [SortOrder("jobDateTime")],
        ),
      );

  final JobRepository jobRepository;
  final UserModel? user;

  @override
  List<SortOption> get sortOptions => const [
    SortOption(label: "jobs_sort_date", properties: ["jobDateTime"]),
  ];

  /// "Only mine" is resolved per request, so the filter in the state stays what the user picked.
  @override
  Future<PaginatedResponse<JobModel>> fetch(ListQuery<JobFilter> query, int page) =>
      jobRepository.getJobs(query, page: page, registeredUserId: query.filter.onlyMine ? user?.id : null);
}

class JobDetailNotifier extends BaseDataNotifier<JobDetailState> {
  JobDetailNotifier(this.jobRepository, this.usersRepository, this.currentUser, this.jobId)
    : super(const JobDetailState()) {
    load();
  }

  final JobRepository jobRepository;
  final UsersRepository usersRepository;
  final UserModel? currentUser;
  final num jobId;

  /// Same rules as the backend (which stays the authority): used to show or hide actions.
  bool get canManageAll => currentUser?.hasPermission(Permission.JOB_MANAGE_ALL) ?? false;

  bool get canEdit {
    final job = state.job;
    if (job == null || currentUser == null) return false;
    return canManageAll || (currentUser!.hasPermission(Permission.JOB_CREATE) && job.createUserId == currentUser!.id);
  }

  bool get canComplete {
    final job = state.job;
    if (job == null || currentUser == null) return false;
    return canManageAll || job.responsibleId == currentUser!.id;
  }

  /// Everyone the current user may register or cancel: themselves, their children, and with JOB_MANAGE_ALL anyone.
  bool canActFor(num userId) => userId == currentUser?.id || state.children.any((c) => c.id == userId) || canManageAll;

  Future<void> load() async {
    await executeApiCall<(JobModel, List<JobRegistrationModel>, List<UserModel>)>(
      () async {
        final job = await jobRepository.getJob(jobId);
        final registrations = await jobRepository.getRegistrations(jobId);
        return (job, registrations, await _loadChildren());
      },
      onSuccess: (loaded) async {
        state = state.copyWith(job: loaded.$1, registrations: loaded.$2, children: loaded.$3);
      },
      onError: (message) async => showApiError(message),
    );
  }

  /// The people the current user may register besides themselves: their spouse, and as a parent their children (the
  /// other, under-18 members of their family).
  Future<List<UserModel>> _loadChildren() async {
    final me = currentUser;
    if (me == null) return [];
    final people = <UserModel>[];
    if (me.spouseId != null) {
      try {
        people.add(await usersRepository.getUserById(me.spouseId!));
      } catch (_) {}
    }
    if (me.isAdult() && me.familyId != null) {
      try {
        final family = await usersRepository.getChildren(me.id);
        people.addAll(family.where((u) => u.id != me.id && u.birthDate != null && !u.isAdult()));
      } catch (_) {}
    }
    final seen = <num>{};
    return people.where((u) => seen.add(u.id)).toList();
  }

  /// Registers [userId] (null = the current user). Reloads on success; failures are shown as a dialog.
  Future<void> register({num? userId, String? comment}) =>
      _action(() => jobRepository.register(jobId, userId: userId, comment: comment));

  Future<void> updateComment({num? userId, String? comment}) =>
      _action(() => jobRepository.updateRegistration(jobId, userId: userId, comment: comment));

  Future<void> cancelRegistration({num? userId}) =>
      _action(() => jobRepository.cancelRegistration(jobId, userId: userId));

  Future<void> cancelJob() => _action(() => jobRepository.cancelJob(jobId));

  /// Cancels this and every later open occurrence of a repeating job.
  Future<void> cancelSeries(String seriesId) => _action(() => jobRepository.cancelSeries(seriesId));

  /// Submits the hours and closes the job. Returns the activity that was created, or null if it failed.
  Future<ActivityModel?> complete(List<JobHoursEntry> entries) async {
    final activity = await executeApiCall<ActivityModel>(
      () => jobRepository.completeJob(jobId, entries),
      onError: (message) async => showApiError(message),
    );
    if (activity != null) await load();
    return activity as ActivityModel?;
  }

  Future<void> _action(Future<dynamic> Function() call) async {
    await executeApiCall(call, onSuccess: (_) => load(), onError: (message) async => showApiError(message));
  }

  @override
  JobDetailState copyWithState(BaseState status) => state.copyWith(status: status);
}
