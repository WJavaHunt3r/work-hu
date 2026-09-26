import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/app_theme_mode.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/settings_tile.dart';
import 'package:work_hu/features/profile/data/state/profile_state.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';

class ProfilePage extends BasePage {
  const ProfilePage({super.key, super.title = "profile_title", super.canRefresh = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends BasePageState<ProfilePage, ProfileState, ProfileDataNotifier> {
  @override
  Widget buildLayout() {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var user = locator<UserProvider>().user;
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
              Text(
                user!.getFullName(),
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.sp),
            ],
          ),
        ),

        SizedBox(height: 40.sp),

        // Personal Information Section
        BaseContainer(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _InfoTile(label: 'profile_full_name'.i18n(), value: user.getFullName()),
              const Divider(height: 1),
              _InfoTile(label: 'profile_email'.i18n(), value: user.email ?? ""),
              const Divider(height: 1),
              _InfoTile(label: 'profile_phone'.i18n(), value: "${user.phoneNumber ?? ""}"),
            ],
          ),
        ),

        SizedBox(height: 32.sp),

        // Account Settings Section
        BaseListView(
          hasBottomPadding: false,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SettingsTile(
              label: 'profile_my_activities'.i18n(),
              icon: Icons.list_alt,
              onTap: () => context.push('/profile/activities'),
              index: 0,
            ),
            Divider(height: 1.sp),
            SettingsTile(
              label: 'profile_booking'.i18n(),
              icon: Icons.book_outlined,
              onTap: () {
                openLink();
              },
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
            SettingsTile(label: 'profile_password_security'.i18n(), icon: Icons.shield_outlined, index: 0),
            const Divider(height: 1),
            SettingsTile(
              label: 'profile_notifications'.i18n(),
              icon: Icons.notifications_none,
            ),
            const Divider(height: 1),
            SettingsTile(
              label: 'profile_language'.i18n(),
              icon: Icons.language,
              trailingText: languageName.toString(),
              onTap: () {
                context.push('/profile/language');
              },
            ),
            const Divider(height: 1),
            SettingsTile(
                label: 'profile_dark_mode'.i18n(),
                icon: Icons.dark_mode_outlined,
                trailingText: AppThemeMode.getThemeModeLocale(currentThemeMode).i18n(),
                onTap: () {
                  context.push('/profile/theme');
                }),
            const Divider(height: 1),
            SettingsTile(label: 'profile_help_support'.i18n(), icon: Icons.help_outline, isLast: true),
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
            label: Text(
              'profile_logout'.i18n(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
                }),
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

  Future<void> openLink() async {
    var token = await ref.read(provider.notifier).token();
    Uri uri = Uri.parse("https://booking.bcc-ktk.org?token=$token");
    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView, webOnlyWindowName: "_self")) {
      throw Exception('booking_failed_to_launch'.i18n([uri.toString()]));
    }
  }
}

class _InfoTile extends StatelessWidget {
  final String label, value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(18.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              SizedBox(height: 4.sp),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          Icon(Icons.edit_outlined, size: 20.sp, color: Theme.of(context).hintColor.withOpacity(0.3)),
        ],
      ),
    );
  }
}
