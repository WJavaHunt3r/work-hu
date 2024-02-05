import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/activity_items/data/api/activity_items_api.dart';
import 'package:work_hu/features/activity_items/data/repository/activity_items_repository.dart';
import 'package:work_hu/features/activity_items/data/state/activity_items_state.dart';

final activityItemsApiProvider = Provider<ActivityItemsApi>((ref) => ActivityItemsApi());

final activityItemsRepoProvider =
    Provider<ActivityItemsRepository>((ref) => ActivityItemsRepository(ref.read(activityItemsApiProvider)));

final activityItemsDataProvider = StateNotifierProvider.autoDispose<ActivityItemsDataNotifier, ActivityItemsState>(
    (ref) => ActivityItemsDataNotifier(ref.read(activityItemsRepoProvider), ref.read(userDataProvider.notifier)));

class ActivityItemsDataNotifier extends StateNotifier<ActivityItemsState> {
  ActivityItemsDataNotifier(
    this.activityRepository,
    this.currentUserProvider,
  ) : super(const ActivityItemsState());

  final ActivityItemsRepository activityRepository;
  final UserDataNotifier currentUserProvider;

  Future<void> getActivityItems({required num activityId}) async {
    state = state.copyWith(modelState: ModelState.processing);
    var user = currentUserProvider.state!;
    try {
      await activityRepository.getActivityItems(activityId: activityId).then((data) async {
        state = state.copyWith(activityItems: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> deleteActivityItem(num num, int index) async {}

}
