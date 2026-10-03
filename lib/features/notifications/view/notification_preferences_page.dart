import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/notifications/data/state/notification_preferences_state.dart';
import 'package:work_hu/features/notifications/providers/notification_preferences_provider.dart';

class NotificationPreferencesPage extends BasePage {
  const NotificationPreferencesPage({super.key, super.title = "notification_preferences_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NotificationPreferencesPageState();
}

class NotificationPreferencesPageState
    extends BasePageState<NotificationPreferencesPage, NotificationPreferencesState, NotificationPreferencesNotifier>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The user may have changed the permission in the system settings and come back.
  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed) ref.read(provider.notifier).refreshPushStatus();
  }

  @override
  void postInit(WidgetRef ref) => ref.read(provider.notifier).load();

  @override
  void onRefresh() => ref.read(provider.notifier).load();

  @override
  Widget buildLayout() {
    final theme = Theme.of(context);
    final notifier = ref.read(provider.notifier);

    // BasePage already pads the layout (16 around), so no outer spacing here. Text outside the boxes is inset like
    // the rows inside them (18), as on the profile page.
    final inset = EdgeInsets.symmetric(horizontal: 18.sp);
    final loading = state.preferences.isEmpty && status.modelState.isAnyLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.pushAvailable && !state.pushAllowed) ...[
          BaseContainer(
            color: theme.colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_off_outlined, color: theme.colorScheme.onPrimaryContainer),
                    SizedBox(width: 12.sp),
                    Expanded(
                      child: Text(
                        'notification_push_off_title'.i18n(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.sp),
                Text(
                  'notification_push_off_hint'.i18n(),
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                ),
                SizedBox(height: 16.sp),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: notifier.enablePush,
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: Text('notification_push_enable'.i18n()),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.sp),
        ],
        Padding(
          padding: inset,
          child: Text(
            'notification_preferences_hint'.i18n(),
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
        ),
        if (loading)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32.sp),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (state.preferences.isEmpty)
          Padding(
            padding: EdgeInsets.all(24.sp),
            child: Center(child: Text('notification_preferences_empty'.i18n(), textAlign: TextAlign.center)),
          )
        else
          for (final channel in _channels()) ...[
            Padding(
              padding: inset.copyWith(top: 24.sp, bottom: 8.sp),
              child: Text(
                'notification_channel_$channel'.i18n(),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            BaseContainer(
              padding: EdgeInsets.zero,
              // Clips the rows' tap highlight to the rounded corners.
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.sp),
                child: Column(
                  children: [
                    for (final (i, preference)
                        in state.preferences.where((p) => (p.channel ?? 'PUSH') == channel).indexed) ...[
                      if (i > 0) const Divider(height: 1),
                      SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 6.sp),
                        title: Text(_label(preference.type), style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: _description(preference.type, theme),
                        value: preference.enabled,
                        onChanged: (value) => notifier.setEnabled(preference.type, value),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
      ],
    );
  }

  List<String> _channels() => {for (final p in state.preferences) p.channel ?? 'PUSH'}.toList();

  /// Backend type names without a translation show as they are.
  String _label(String type) {
    final key = 'notification_type_$type';
    final label = key.i18n();
    return label == key ? type : label;
  }

  Widget? _description(String type, ThemeData theme) {
    final key = 'notification_type_${type}_hint';
    final text = key.i18n();
    return text == key
        ? null
        : Padding(
            padding: EdgeInsets.only(top: 2.sp),
            child: Text(text, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          );
  }

  @override
  StateNotifierProvider<NotificationPreferencesNotifier, NotificationPreferencesState> get provider =>
      notificationPreferencesProvider;

  @override
  BaseState get status => state.status;
}
