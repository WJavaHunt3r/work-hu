import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activities/data/api/activity_api.dart';
import 'package:work_hu/features/activities/data/model/activity_filter.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

import '../data/repository/activity_repository.dart';

final activityApiProvider = Provider<ActivityApi>((ref) => ActivityApi());

final activityRepoProvider = Provider<ActivityRepository>((ref) => ActivityRepository(ref.read(activityApiProvider)));

final activityDataProvider =
    StateNotifierProvider.autoDispose<ActivityDataNotifier, PagedState<ActivityModel, ActivityFilter>>(
      (ref) => ActivityDataNotifier(ref.read(activityRepoProvider), ref.read(userDataProvider).user),
    );

class ActivityDataNotifier extends PagedListNotifier<ActivityModel, ActivityFilter> {
  ActivityDataNotifier(this.activityRepository, this.user)
    : super(
        ListQuery(
          filter: ActivityFilter(referenceDate: DateTime(DateTime.now().year, DateTime.now().month, 1)),
          sort: const [SortOrder("activityDateTime", SortDir.desc)],
        ),
      );

  final ActivityRepository activityRepository;
  final UserModel? user;

  /// Users without the activity permissions only see activities they created, are responsible for or are employed in.
  /// Applied per request, so the filter in the state stays what the user picked.
  @override
  Future<PaginatedResponse<ActivityModel>> fetch(ListQuery<ActivityFilter> query, int page) {
    final seesAll =
        user!.isAdmin() ||
        user!.hasPermission(Permission.ACTIVITY_MANAGE_ALL) ||
        user!.hasPermission(Permission.ACTIVITY_REGISTER);
    final scoped = seesAll
        ? query
        : query.copyWith(
            filter: query.filter.copyWith(responsible: user, createUser: user, employer: user),
          );
    return activityRepository.getActivities(scoped, page: page);
  }

  Future<void> deleteActivity(num id) async {
    await executeApiCall(
      () => activityRepository.deleteActivity(id, user!.id),
      onSuccess: (_) async => removeItems((activity) => activity.id == id),
    );
  }

  Future<void> registerActivity(num id) async {
    await executeApiCall(() => activityRepository.registerActivity(id, user!.id), onSuccess: (_) => reload());
  }

  Future<void> putActivity(ActivityModel activity) async {
    await executeApiCall(() => activityRepository.putActivity(activity, activity.id!), onSuccess: (_) => reload());
  }

  Future<void> registerActivityInTeams(num id) async {
    await executeApiCall(() => activityRepository.registerActivityInTeams(id, user!.id), onSuccess: (_) => reload());
  }
}
