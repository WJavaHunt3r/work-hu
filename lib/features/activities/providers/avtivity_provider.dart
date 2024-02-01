import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/activities/data/api/activity_api.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/data/state/activity_state.dart';

import '../data/repository/activity_repository.dart';

final activityApiProvider = Provider<ActivityApi>((ref) => ActivityApi());

final activityRepoProvider = Provider<ActivityRepository>((ref) => ActivityRepository(ref.read(activityApiProvider)));

final activityDataProvider = StateNotifierProvider.autoDispose<ActivityDataNotifier, ActivityState>(
    (ref) => ActivityDataNotifier(ref.read(activityRepoProvider), ref.read(userDataProvider.notifier)));

class ActivityDataNotifier extends StateNotifier<ActivityState> {
  ActivityDataNotifier(
    this.activityRepository,
    this.currentUserProvider,
  ) : super(const ActivityState());

  final ActivityRepository activityRepository;
  final UserDataNotifier currentUserProvider;

  Future<void> getActivities(
      {num? responsibleId,
      num? employerId,
      num? createUserId,
      bool? registeredInApp,
      bool? registeredInMyShare}) async {
    state = state.copyWith(modelState: ModelState.processing);
    var user = currentUserProvider.state!;
    if (user.role == Role.ADMIN) {
    }
    try {
      await activityRepository
          .getActivities(
              registeredInApp: registeredInApp,
              registeredInMyShare: registeredInMyShare,
              responsibleId: responsibleId,
              createUserId: createUserId,
              employerId: employerId)
          .then((data) async {
        state = state.copyWith(activities: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> deleteActivity(num id, int index) async {
    List<ActivityModel> items = [];
    for (var a in state.activities) {
      if (a.id != id) {
        items.add(a);
      }
    }
    state = state.copyWith(activities: items, modelState: ModelState.processing);
    var user = currentUserProvider.state!;
    try {
      await activityRepository.deleteActivity(id, user.id).then((data) async {
        state = state.copyWith(activities: items, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }
}
