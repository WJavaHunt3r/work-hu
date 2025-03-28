import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activities/data/api/activity_api.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/data/state/activity_state.dart';
import 'package:work_hu/features/activity_items/data/repository/activity_items_repository.dart';
import 'package:work_hu/features/activity_items/provider/activity_items_provider.dart';
import 'package:work_hu/features/rounds/data/state/rounds_state.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';

import '../data/repository/activity_repository.dart';

final activityApiProvider = Provider<ActivityApi>((ref) => ActivityApi());

final activityRepoProvider = Provider<ActivityRepository>((ref) => ActivityRepository(ref.read(activityApiProvider)));

final activityDataProvider = StateNotifierProvider.autoDispose<ActivityDataNotifier, ActivityState>((ref) =>
    ActivityDataNotifier(ref.read(activityRepoProvider), ref.read(userDataProvider.notifier),
        ref.read(activityItemsRepoProvider), ref.read(roundDataProvider)));

class ActivityDataNotifier extends StateNotifier<ActivityState> {
  ActivityDataNotifier(
    this.activityRepository,
    this.currentUserProvider,
    this.activityItemsRepository,
    this.roundsProvider,
  ) : super(ActivityState(referenceDate: DateTime.now())) {
    getActivities();
  }

  final ActivityRepository activityRepository;
  final ActivityItemsRepository activityItemsRepository;
  final UserDataNotifier currentUserProvider;
  final RoundsState roundsProvider;

  Future<void> getActivities(
      {num? responsibleId,
      num? employerId,
      num? createUserId,
      bool? registeredInApp,
      String? searchText,
      bool? registeredInMyShare}) async {
    state = state.copyWith(modelState: ModelState.processing, registerState: ModelState.empty);
    var user = currentUserProvider.state!;
    if (user.role != Role.ADMIN) {
      employerId = user.id;
      responsibleId=user.id;
      createUserId=user.id;
    }
    try {
      await activityRepository
          .getActivities(
          registeredInApp: false,
          registeredInMyShare: false,
          responsibleId: responsibleId,
          createUserId: createUserId,
          searchText: searchText,
          employerId: employerId)
          .then((data) async {
        data.sort((a, b) => b.activityDateTime.compareTo(a.activityDateTime));
        state = state.copyWith(activities: data, modelState: ModelState.success);
      });
      await activityRepository
          .getActivities(
              registeredInApp: true,
              registeredInMyShare: registeredInMyShare,
              responsibleId: responsibleId,
              createUserId: createUserId,
              referenceDate: state.referenceDate,
              searchText: searchText,
              employerId: employerId)
          .then((data) async {
        data.sort((a, b) => b.activityDateTime.compareTo(a.activityDateTime));
        state = state.copyWith(activities: [... state.activities,... data], modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> deleteActivity(num id, int index) async {
    List<ActivityModel> origItems = state.activities;
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
      state = state.copyWith(modelState: ModelState.error, activities: origItems);
    }
  }

  void updateIsExpanded(bool isExpanded) {
    state = state.copyWith(isExpanded: isExpanded);
  }

  void setReferenceDate(DateTime? date) {
    state = state.copyWith(referenceDate: date);
    getActivities();
  }

  Future<void> registerActivity(num id) async {
    state = state.copyWith(modelState: ModelState.processing);
    var user = currentUserProvider.state!;
    try {
      await activityRepository.registerActivity(id, user.id).then((data) async {
        state = state.copyWith(message: data, modelState: ModelState.success, registerState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> putActivity(ActivityModel activity) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await activityRepository.putActivity(activity, activity.id!).then((data) async {
        getActivities();
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> registerActivityInTeams(num id) async {
    state = state.copyWith(modelState: ModelState.processing, registerState: ModelState.processing);
    var user = currentUserProvider.state!;
    try {
      await activityRepository.registerActivityInTeams(id, user.id).then((data) async {
        state = state.copyWith(message: data, modelState: ModelState.success, registerState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }
}
