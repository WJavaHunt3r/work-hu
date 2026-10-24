import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/reading_plan/data/model/reading_plan_model.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';

/// The reading challenge: the 150 psalms to tick off, the ranking and the plan.
class PsalmsPage extends ConsumerWidget {
  const PsalmsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readingPlanProvider);
    final plan = state.plan;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(plan?.title ?? "reading_plan_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: "reading_plan_tab_read".i18n()),
              Tab(text: "reading_plan_tab_articles".i18n()),
              Tab(text: "reading_plan_tab_ranking".i18n()),
              Tab(text: "reading_plan_tab_plan".i18n()),
            ],
          ),
        ),
        body: state.loading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : plan == null
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(24.sp),
                  child: Text(state.error ?? "reading_plan_none".i18n(), textAlign: TextAlign.center),
                ),
              )
            : TabBarView(
                children: [
                  _ReadTab(plan: plan),
                  _ArticlesTab(plan: plan),
                  _RankingTab(plan: plan),
                  _PlanTab(plan: plan),
                ],
              ),
      ),
    );
  }
}

class _ReadTab extends ConsumerWidget {
  const _ReadTab({required this.plan});

  final ReadingPlanModel plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final week = plan.weekOn(DateTime.now());
    final next = plan.nextUnread;
    return RefreshIndicator.adaptive(
      onRefresh: () => ref.read(readingPlanProvider.notifier).load(),
      child: ListView(
        padding: EdgeInsets.all(16.sp),
        children: [
          BaseContainer(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("reading_plan_progress".i18n([plan.readCount.toString(), plan.itemCount.toString()])),
                    Text("${(plan.progress * 100).round()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 6.sp),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.sp),
                  child: LinearProgressIndicator(value: plan.progress, minHeight: 10.sp),
                ),
                if (week != null) ...[
                  SizedBox(height: 10.sp),
                  Text(
                    "reading_plan_week_goal".i18n([
                      week.weekNumber.toString(),
                      plan.readIn(week).toString(),
                      week.size.toString(),
                    ]),
                  ),
                ],
              ],
            ),
          ),
          if (!plan.open)
            Padding(
              padding: EdgeInsets.only(top: 12.sp),
              child: Text(
                (DateTime.now().isBefore(plan.startDate) ? "reading_plan_not_started" : "reading_plan_ended").i18n(),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
              ),
            ),
          if (next != null)
            Padding(
              padding: EdgeInsets.only(top: 12.sp),
              child: FilledButton.icon(
                onPressed: () => context.push('/psalms/$next'),
                icon: const Icon(Icons.play_arrow),
                label: Text("reading_plan_continue".i18n([next.toString()])),
              ),
            ),
          SizedBox(height: 12.sp),
          Text("reading_plan_tap_hint".i18n(), style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          SizedBox(height: 8.sp),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8.sp,
              crossAxisSpacing: 8.sp,
            ),
            itemCount: plan.itemCount,
            itemBuilder: (context, index) {
              final n = index + 1;
              return _PsalmTile(n: n, done: plan.myItems.contains(n), thisWeek: week?.contains(n) ?? false);
            },
          ),
        ],
      ),
    );
  }
}

class _PsalmTile extends StatelessWidget {
  const _PsalmTile({required this.n, required this.done, required this.thisWeek});

  final int n;
  final bool done;
  final bool thisWeek;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: "reading_plan_psalm_label".i18n([
        n.toString(),
        (done ? "reading_plan_read" : "reading_plan_unread").i18n(),
      ]),
      child: Material(
        color: done ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.sp),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.sp),
          onTap: () => context.push('/psalms/$n'),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              border: Border.all(
                color: thisWeek && !done ? scheme.primary : scheme.outlineVariant,
                width: thisWeek && !done ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$n",
                  style: TextStyle(fontWeight: FontWeight.w700, color: done ? scheme.onPrimary : scheme.onSurface),
                ),
                if (done) Icon(Icons.check, size: 14.sp, color: scheme.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RankingTab extends ConsumerWidget {
  const _RankingTab({required this.plan});

  final ReadingPlanModel plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(leaderboardProvider(plan.id));
    final myId = ref.watch(userDataProvider).user?.id;
    final theme = Theme.of(context);
    return RefreshIndicator.adaptive(
      onRefresh: () async => ref.refresh(leaderboardProvider(plan.id).future),
      child: board.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (_, _) => ListView(
          children: [Padding(padding: EdgeInsets.all(24.sp), child: Text("api_unknown_error".i18n()))],
        ),
        data: (data) => ListView(
          padding: EdgeInsets.all(16.sp),
          children: [
            BaseContainer(
              padding: EdgeInsets.all(16.sp),
              child: Text(
                data.myRank == null
                    ? "reading_plan_my_rank_none".i18n()
                    : "reading_plan_my_rank".i18n([data.myRank.toString(), data.myPoints.toString()]),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (data.myArticlePoints > 0)
              Padding(
                padding: EdgeInsets.only(top: 6.sp, left: 4.sp),
                child: Text(
                  "reading_plan_breakdown".i18n([data.myCount.toString(), data.myArticlePoints.toString()]),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                ),
              ),
            SizedBox(height: 12.sp),
            if (data.entries.isEmpty)
              Padding(padding: EdgeInsets.all(16.sp), child: Text("reading_plan_ranking_empty".i18n()))
            else
              BaseContainer(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
                child: Column(
                  children: [
                    for (final e in data.entries)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.sp),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16.sp,
                              backgroundColor: e.userId == myId
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.primary.withValues(alpha: 0.15),
                              child: Text(
                                "${e.rank}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: e.userId == myId ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.sp),
                            Expanded(
                              child: Text(
                                e.name,
                                style: TextStyle(fontWeight: e.userId == myId ? FontWeight.bold : FontWeight.normal),
                              ),
                            ),
                            Text(
                              "reading_plan_points".i18n([e.count.toString()]),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlanTab extends StatelessWidget {
  const _PlanTab({required this.plan});

  final ReadingPlanModel plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final format = DateFormat('yyyy.MM.dd.');
    final today = plan.weekOn(DateTime.now());
    return ListView(
      padding: EdgeInsets.all(16.sp),
      children: [
        BaseContainer(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plan.description.isNotEmpty) Text(plan.description),
              SizedBox(height: 8.sp),
              Text(
                "reading_plan_dates".i18n([format.format(plan.startDate), format.format(plan.endDate)]),
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.sp),
              Text(
                "reading_plan_totals".i18n([plan.participants.toString(), plan.totalReadings.toString()]),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.sp),
        for (final w in plan.weeks)
          Padding(
            padding: EdgeInsets.only(bottom: 8.sp),
            child: BaseContainer(
              padding: EdgeInsets.all(16.sp),
              color: w == today ? theme.colorScheme.primary.withValues(alpha: 0.12) : null,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "reading_plan_week_title".i18n([
                            w.weekNumber.toString(),
                            w.startItem.toString(),
                            w.endItem.toString(),
                          ]),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${format.format(w.startsOn)} – ${format.format(w.endsOn)}",
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                        ),
                      ],
                    ),
                  ),
                  Text("${plan.readIn(w)}/${w.size}", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// The articles of the plan, read for extra points.
class _ArticlesTab extends ConsumerWidget {
  const _ArticlesTab({required this.plan});

  final ReadingPlanModel plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final articles = ref.watch(articlesProvider(plan.id));
    return RefreshIndicator.adaptive(
      onRefresh: () async => ref.refresh(articlesProvider(plan.id).future),
      child: articles.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (_, _) => ListView(
          children: [Padding(padding: EdgeInsets.all(24.sp), child: Text("api_unknown_error".i18n()))],
        ),
        data: (list) => list.isEmpty
            ? ListView(
                children: [Padding(padding: EdgeInsets.all(24.sp), child: Text("reading_plan_articles_none".i18n()))],
              )
            : ListView(
                padding: EdgeInsets.all(16.sp),
                children: [
                  Text(
                    "reading_plan_articles_hint".i18n(),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                  SizedBox(height: 8.sp),
                  for (final a in list)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.sp),
                      child: BaseContainer(
                        padding: EdgeInsets.all(16.sp),
                        onTap: () async {
                          await context.push('/psalms/article/${a.id}');
                          ref.invalidate(articlesProvider(plan.id));
                        },
                        child: Row(
                          children: [
                            Icon(
                              a.read ? Icons.check_circle : Icons.article_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            SizedBox(width: 12.sp),
                            Expanded(
                              child: Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Text(
                              "reading_plan_article_points".i18n([a.points.toString()]),
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
