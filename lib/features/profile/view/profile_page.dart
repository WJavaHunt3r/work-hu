import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/app_theme_mode.dart';
import 'package:work_hu/app/providers/locale_provider.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/settings_tile.dart';
import 'package:work_hu/features/profile/data/state/profile_state.dart';
import 'package:work_hu/features/profile/view/account_deletion.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/reading_plan/view/reading_plan_card.dart';

class ProfilePage extends BasePage {
  const ProfilePage({super.key, super.title = "profile_title", super.canRefresh = false, this.inSheet = false})
    : super(showBackButton: !inSheet);

  /// Shown as the sheet the header's avatar opens: a close button instead of back.
  final bool inSheet;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends BasePageState<ProfilePage, ProfileState, ProfileDataNotifier> {
  @override
  List<Widget>? buildActions(BuildContext context, WidgetRef ref) => widget.inSheet
      ? [
          IconButton.outlined(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ]
      : null;

  @override
  Widget buildLayout() {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var user = ref.watch(userDataProvider).user;
    final currentLocale = ref.watch(localeProvider);

    final localeNames = LocaleNames.of(context)!;

    final languageName = localeNames.nameOf(currentLocale.value!.languageCode);

    final currentThemeMode = ref.watch(themeProvider);

    return Column(
      children: [
        SizedBox(height: 24.sp),

        // Header Profile Section
        Center(
          child: Column(
            children: [
              SizedBox(height: 16.sp),
              Text(user!.getFullName(), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 4.sp),
              if (user.churchName != null)
                Text(user.churchName!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
            ],
          ),
        ),

        SizedBox(height: 40.sp),

        // Users without a church have no Status page, so its reading challenge card (for those who may see it) is here
        if (!user.hasChurch()) ...[const ReadingPlanCard(), SizedBox(height: 8.sp)],

        // Personal details: their own page, where the name, gender and birth date are edited
        BaseListView(
          hasBottomPadding: false,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SettingsTile(
              label: 'profile_details_title'.i18n(),
              icon: Icons.person_outline,
              onTap: () => context.push('/profile/details'),
              index: 0,
              isLast: true,
            ),
          ],
        ),

        SizedBox(height: 32.sp),

        // App Settings Section
        BaseListView(
          hasBottomPadding: false,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SettingsTile(
              label: 'profile_password_security'.i18n(),
              icon: Icons.shield_outlined,
              onTap: () => context.push('/profile/security'),
              index: 0,
            ),
            SettingsTile(
              label: 'profile_notifications'.i18n(),
              icon: Icons.notifications_none,
              onTap: () => context.push('/profile/notifications'),
            ),
            SettingsTile(
              label: 'profile_language'.i18n(),
              icon: Icons.language,
              trailingText: languageName.toString(),
              onTap: () {
                context.push('/profile/language');
              },
            ),
            SettingsTile(
              label: 'profile_dark_mode'.i18n(),
              icon: Icons.dark_mode_outlined,
              trailingText: AppThemeMode.getThemeModeLocale(currentThemeMode).i18n(),
              onTap: () {
                context.push('/profile/theme');
              },
            ),
            SettingsTile(label: 'profile_help_support'.i18n(), icon: Icons.help_outline),
            SettingsTile(
              label: 'profile_delete_account'.i18n(),
              icon: Icons.delete_forever_outlined,
              onTap: () => requestAccountDeletion(context),
              isLast: true,
            ),
          ],
        ),

        SizedBox(height: 32.sp),

        // Logout Button
        SizedBox(
          width: double.infinity,
          height: 56.sp,
          child: FilledButton.icon(
            onPressed: () {
              ref.read(provider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.errorContainer, // Soft red from image
              foregroundColor: colorScheme.error, // Strong red
            ),
            icon: const Icon(Icons.logout),
            label: Text('profile_logout'.i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),

        SizedBox(height: 32.sp),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, data) {
                if (!data.hasData) return const Text(" ");
                return Text("profile_version".i18n([data.data!.version]));
              },
            ),
          ],
        ),
        SizedBox(height: 32.sp),
      ],
    );
  }

  @override
  StateNotifierProvider<ProfileDataNotifier, ProfileState> get provider => profileDataProvider;

  @override
  BaseState get status => state.status;
}
