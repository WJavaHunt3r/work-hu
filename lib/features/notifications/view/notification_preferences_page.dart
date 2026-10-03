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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.sp),
        if (state.pushAvailable && !state.pushAllowed) ...[
          BaseContainer(
            color: theme.colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('notification_push_off_title'.i18n(), style: theme.textTheme.titleMedium),
                SizedBox(height: 8.sp),
                Text('notification_push_off_hint'.i18n(), style: theme.textTheme.bodyMedium),
                SizedBox(height: 16.sp),
                FilledButton.icon(
                  onPressed: notifier.enablePush,
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: Text('notification_push_enable'.i18n()),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.sp),
        ],
        Text('notification_preferences_hint'.i18n(), style: theme.textTheme.bodySmall),
        SizedBox(height: 12.sp),
        if (state.preferences.isEmpty && !status.modelState.isLoading)
          Padding(
            padding: EdgeInsets.all(24.sp),
            child: Center(child: Text('notification_preferences_empty'.i18n())),
          )
        else
          for (final channel in _channels()) ...[
            Padding(
              padding: EdgeInsets.only(left: 8.sp, bottom: 8.sp, top: 8.sp),
              child: Text('notification_channel_$channel'.i18n(), style: theme.textTheme.titleSmall),
            ),
            BaseContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final (i, preference)
                      in state.preferences.where((p) => (p.channel ?? 'PUSH') == channel).indexed) ...[
                    if (i > 0) const Divider(height: 1),
                    SwitchListTile(
                      title: Text(_label(preference.type)),
                      subtitle: _description(preference.type),
                      value: preference.enabled,
                      onChanged: (value) => notifier.setEnabled(preference.type, value),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16.sp),
          ],
        SizedBox(height: 32.sp),
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

  Widget? _description(String type) {
    final key = 'notification_type_${type}_hint';
    final text = key.i18n();
    return text == key ? null : Text(text);
  }

  @override
  StateNotifierProvider<NotificationPreferencesNotifier, NotificationPreferencesState> get provider =>
      notificationPreferencesProvider;

  @override
  BaseState get status => state.status;
}
