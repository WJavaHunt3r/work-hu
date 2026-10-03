import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/notifications/data/model/notification_preference_model.dart';

part 'notification_preferences_state.freezed.dart';

@freezed
abstract class NotificationPreferencesState with _$NotificationPreferencesState {
  const factory NotificationPreferencesState({
    @Default(BaseState()) BaseState status,
    @Default([]) List<NotificationPreferenceModel> preferences,

    /// Whether this device may show pushes (OS / browser permission).
    @Default(false) bool pushAllowed,
    @Default(false) bool pushAvailable,
  }) = _NotificationPreferencesState;

  const NotificationPreferencesState._();
}
