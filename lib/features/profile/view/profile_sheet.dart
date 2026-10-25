import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/profile/view/profile_page.dart';

/// The user's initials in a circle, at the start of each tab's header: opens the profile as a sheet.
class ProfileAvatarButton extends ConsumerWidget {
  const ProfileAvatarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(userDataProvider).user;
    String first(String? s) => (s == null || s.trim().isEmpty) ? '' : s.trim().substring(0, 1).toUpperCase();
    final initials = '${first(user?.firstname)}${first(user?.lastname)}';
    return Center(
      child: Tooltip(
        message: "profile_title".i18n(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => showProfileSheet(context),
          child: Container(
            width: 36.sp,
            height: 36.sp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceContainerHighest,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: initials.isEmpty
                ? Icon(Icons.person_outline, size: 20.sp)
                : Text(initials, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}

/// The profile as a tall sheet over the current tab (its pages, e.g. language or theme, open above it and come back
/// to it). `/profile` itself still opens it as a page, for links that point there.
Future<void> showProfileSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  useRootNavigator: true,
  clipBehavior: Clip.antiAlias,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.sp))),
  builder: (context) => const FractionallySizedBox(heightFactor: 0.95, child: ProfilePage(inSheet: true)),
);
