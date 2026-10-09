import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/notifications/push_service.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/notifications/data/api/notification_api.dart';
import 'package:work_hu/features/notifications/data/model/notification_preference_model.dart';
import 'package:work_hu/features/notifications/data/repository/notification_repository.dart';
import 'package:work_hu/features/notifications/data/state/notification_preferences_state.dart';

final notificationApiProvider = Provider<NotificationApi>((ref) => NotificationApi());
final notificationRepoProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepository(ref.read(notificationApiProvider)),
);

final notificationPreferencesProvider =
    StateNotifierProvider.autoDispose<NotificationPreferencesNotifier, NotificationPreferencesState>(
      (ref) => NotificationPreferencesNotifier(ref.read(notificationRepoProvider)),
    );

class NotificationPreferencesNotifier extends BaseDataNotifier<NotificationPreferencesState> {
  NotificationPreferencesNotifier(this._repository) : super(const NotificationPreferencesState());

  final NotificationRepository _repository;

  Future<void> load() async {
    await refreshPushStatus();
    await executeApiCall<List<NotificationPreferenceModel>>(
      () => _repository.getPreferences(),
      onSuccess: (preferences) async {
        state = state.copyWith(
          status: const BaseState(modelState: ModelState.success),
          preferences: preferences,
        );
      },
    );
  }

  Future<void> refreshPushStatus() async {
    final status = await PushService.instance.status();
    if (!mounted) return;
    state = state.copyWith(pushStatus: status, pushDetail: PushService.instance.lastError);
  }

  /// Registers this device again, for when permission is given but registration failed.
  Future<void> retryRegistration() async {
    await PushService.instance.registerCurrentDevice();
    await refreshPushStatus();
  }

  /// Sends a test notification to all of the user's devices. Returns the backend's reason when it failed.
  Future<({NotificationTestResult? result, String? error})> sendTest() async {
    try {
      return (result: await _repository.sendTest(), error: null);
    } on ApiException catch (e) {
      return (result: null, error: e.message);
    } catch (_) {
      return (result: null, error: 'api_unknown_error');
    }
  }

  /// Asks for permission on this device and registers it for pushes.
  Future<void> enablePush() async {
    await PushService.instance.requestPermissionAndRegister();
    await refreshPushStatus();
  }

  /// Applies the switch at once and rolls it back if the backend refuses.
  Future<void> setEnabled(String type, bool enabled) async {
    final previous = state.preferences;
    final updated = [for (final p in previous) p.type == type ? p.copyWith(enabled: enabled) : p];
    state = state.copyWith(preferences: updated);
    try {
      final saved = await _repository.setEnabled(type, enabled);
      if (mounted) state = state.copyWith(preferences: saved);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(preferences: previous);
      showApiError(e is ApiException ? e.message : 'api_unknown_error');
    }
  }

  @override
  NotificationPreferencesState copyWithState(BaseState status) => state.copyWith(status: status);
}
