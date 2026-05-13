import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activities/data/api/activity_api.dart';
import 'package:work_hu/features/activities/data/model/activity_filter.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/data/state/activity_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

import '../data/repository/activity_repository.dart';

final activityApiProvider = Provider<ActivityApi>((ref) => ActivityApi());

final activityRepoProvider = Provider<ActivityRepository>((ref) => ActivityRepository(ref.read(activityApiProvider)));

final activityDataProvider = StateNotifierProvider.autoDispose<ActivityDataNotifier, ActivityState>(
    (ref) => ActivityDataNotifier(ref.read(activityRepoProvider)));

class ActivityDataNotifier extends BaseDataNotifier<ActivityState> implements ListApiProvider<ActivityFilter> {
  ActivityDataNotifier(
    this.activityRepository,
  ) : super(ActivityState(filter: ActivityFilter(referenceDate: DateTime(DateTime.now().year, DateTime.now().month, 1)))) {
    list();
  }

  final ActivityRepository activityRepository;
  final UserModel? user = locator<UserProvider>().user;

  @override
  Future<void> list({ActivityFilter? filter, int? page, int? size, List<String>? sort}) async {
    var sort = SortBuilder()..add("activityDateTime", descending: true);
    state = state.copyWith(filter: filter ?? state.filter);

    await executeApiCall<PaginatedResponse<ActivityModel>>(
        () => activityRepository.getActivities(
            registeredInMyShare: state.filter.registeredInMyShare,
            responsibleId: user!.isAdmin() ? state.filter.responsible?.id : user!.id,
            createUserId: user!.isAdmin() ? state.filter.createUser?.id : user!.id,
            referenceDate: state.filter.referenceDate,
            searchText: state.filter.description,
            employerId: user!.isAdmin() ? state.filter.employer?.id : user!.id,
            page: page ?? state.status.number,
            size: size ?? state.status.size,
            sort: sort.build()), onSuccess: (data) async {
      state = state.copyWith(
          activities: state.status.number == 0 ? data.content : [...state.activities, ...data.content],
          status: state.status
              .copyWith(totalElements: data.page.totalElements, totalPages: data.page.totalPages, number: data.page.number));
    });
  }

  Future<void> deleteActivity(num id) async {
    executeApiCall(() => activityRepository.deleteActivity(id, user!.id), onSuccess: (data) => list());
  }

  Future<void> registerActivity(num id) async {
    executeApiCall(() => activityRepository.registerActivity(id, user!.id), onSuccess: (data) => list());
  }

  Future<void> putActivity(ActivityModel activity) async {
    executeApiCall(() => activityRepository.putActivity(activity, activity.id!), onSuccess: (data) async {
      list();
    });
  }

  Future<void> registerActivityInTeams(num id) async {
    executeApiCall(() => activityRepository.registerActivityInTeams(id, user!.id), onSuccess: (data) => list());
  }

  @override
  ActivityState copyWithState(BaseState status) {
    return state.copyWith(status: state.status.copyWith(baseStatus: status));
  }
}
