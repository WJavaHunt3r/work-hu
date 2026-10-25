import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/bible/providers/bible_provider.dart';
import 'package:work_hu/features/profile/view/profile_sheet.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';
import 'package:work_hu/features/reading_plan/view/reading_plan_card.dart';
import 'package:work_hu/features/status/providers/status_providers.dart';
import 'package:work_hu/features/status/view/status_page.dart' show LocalStatusSection;
import 'package:work_hu/features/streams/view/live_page.dart';

/// The first tab (`/home`): for church members the live broadcast banner, the reading challenge, the church's status
/// this month and the Bible; for users without a church only the Bible. The header's avatar opens the profile.
class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final church = ref.watch(userDataProvider).user?.hasChurch() ?? false;
    return Scaffold(
      appBar: AppBar(
        leading: const ProfileAvatarButton(),
        title: Text("start_title".i18n(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          if (church) ref.read(statusDataProvider.notifier).getUserInfoAndUserRounds();
          await ref.read(readingPlanProvider.notifier).load();
        },
        child: ListView(
          padding: EdgeInsets.all(16.sp),
          children: [
            if (church) ...[
              // Each shows itself only when there is something to show (a broadcast, a plan the user may see)
              const LiveBanner(),
              const ReadingPlanCard(),
              const _LocalStatus(),
              SizedBox(height: 16.sp),
            ],
            const _BibleCard(),
          ],
        ),
      ),
    );
  }
}

class _LocalStatus extends ConsumerWidget {
  const _LocalStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      LocalStatusSection(head: ref.watch(statusDataProvider.select((s) => s.userRoundHead)));
}

/// The Bible: "Continue" at the last chapter read (its name remembered, so nothing is downloaded for it), else open.
class _BibleCard extends ConsumerWidget {
  const _BibleCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final position = ref.watch(biblePositionProvider);
    final label = position?.label;
    return BaseContainer(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
            leading: Icon(Icons.menu_book, color: theme.colorScheme.primary),
            title: Text("bible_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              position != null && label != null ? "bible_continue".i18n([label]) : "start_bible_subtitle".i18n(),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(position != null && label != null ? position.route : '/bible'),
          ),
          if (position != null && label != null) ...[
            const Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
              leading: Icon(Icons.grid_view, color: theme.colorScheme.primary),
              title: Text("start_bible_books".i18n()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/bible'),
            ),
          ],
        ],
      ),
    );
  }
}
