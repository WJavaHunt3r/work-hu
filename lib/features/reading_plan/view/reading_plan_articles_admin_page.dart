import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';

/// Admin → Reading plan: the articles of the challenge (drafts too). Tap one to edit it, "+" writes a new one.
class ReadingPlanArticlesAdminPage extends ConsumerWidget {
  const ReadingPlanArticlesAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(readingPlanProvider);
    final plan = state.plan;
    return Scaffold(
      appBar: AppBar(
        title: Text("reading_plan_admin_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: "reading_plan_reported_title".i18n(),
            icon: const Icon(Icons.flag_outlined),
            onPressed: () => context.push('/admin/readingPlan/reported'),
          ),
        ],
      ),
      floatingActionButton: plan == null
          ? null
          : FloatingActionButton(
              tooltip: "reading_plan_admin_new".i18n(),
              onPressed: () async {
                await context.push<bool>('/admin/readingPlan/new');
                ref.invalidate(adminArticlesProvider(plan.id));
              },
              child: const Icon(Icons.add),
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
          : RefreshIndicator.adaptive(
              onRefresh: () async => ref.refresh(adminArticlesProvider(plan.id).future),
              child: ref
                  .watch(adminArticlesProvider(plan.id))
                  .when(
                    loading: () => const Center(child: CircularProgressIndicator.adaptive()),
                    error: (error, _) => ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(24.sp),
                          child: Text(error is ApiException ? error.message : "api_unknown_error".i18n()),
                        ),
                      ],
                    ),
                    data: (articles) => articles.isEmpty
                        ? ListView(
                            children: [
                              Padding(padding: EdgeInsets.all(24.sp), child: Text("reading_plan_admin_none".i18n())),
                            ],
                          )
                        : ListView(
                            padding: EdgeInsets.all(16.sp),
                            children: [
                              for (final a in articles)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.sp),
                                  child: BaseContainer(
                                    padding: EdgeInsets.all(16.sp),
                                    onTap: () async {
                                      await context.push<bool>('/admin/readingPlan/${a.id}');
                                      ref.invalidate(adminArticlesProvider(plan.id));
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                              Text(
                                                "reading_plan_article_points".i18n([a.points.toString()]),
                                                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (!a.published)
                                          Chip(
                                            label: Text("reading_plan_admin_draft".i18n()),
                                            visualDensity: VisualDensity.compact,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
            ),
    );
  }
}
