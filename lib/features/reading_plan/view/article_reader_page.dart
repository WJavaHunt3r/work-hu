import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/reading_plan/view/article_body.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';

/// One article of the reading plan, read only, with the "I have read it" button that gives its extra points.
class ArticleReaderPage extends ConsumerStatefulWidget {
  const ArticleReaderPage({super.key, required this.articleId});

  final num articleId;

  @override
  ConsumerState<ArticleReaderPage> createState() => _ArticleReaderPageState();
}

class _ArticleReaderPageState extends ConsumerState<ArticleReaderPage> {
  bool _busy = false;

  Future<void> _setRead(num planId, bool read) async {
    setState(() => _busy = true);
    try {
      await ref.read(readingPlanRepoProvider).setArticleRead(planId, widget.articleId, read: read);
      ref.invalidate(articleProvider((planId: planId, id: widget.articleId)));
      ref.invalidate(articlesProvider(planId));
      ref.invalidate(leaderboardProvider(planId));
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plan = ref.watch(readingPlanProvider).plan;
    if (plan == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text("reading_plan_none".i18n())),
      );
    }
    final article = ref.watch(articleProvider((planId: plan.id, id: widget.articleId)));
    return Scaffold(
      appBar: AppBar(
        title: Text("reading_plan_tab_articles".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: article.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(24.sp),
            child: Text(
              error is ApiException ? error.message : "api_unknown_error".i18n(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (a) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.sp),
                children: [
                  Text(a.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.sp),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      avatar: Icon(a.read ? Icons.check_circle : Icons.stars_outlined, size: 18.sp),
                      label: Text("reading_plan_article_points".i18n([a.points.toString()])),
                    ),
                  ),
                  if (a.language != ref.watch(appLanguageProvider))
                    Padding(
                      padding: EdgeInsets.only(top: 8.sp),
                      child: Text(
                        "reading_plan_article_other_language".i18n(),
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                    ),
                  SizedBox(height: 12.sp),
                  ArticleBody(body: a.body),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 8.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: a.read
                          ? FilledButton.tonalIcon(
                              onPressed: _busy || !plan.open ? null : () => _setRead(plan.id, false),
                              icon: const Icon(Icons.check_circle),
                              label: Text("reading_plan_article_undo".i18n()),
                            )
                          : FilledButton.icon(
                              onPressed: _busy || !plan.open ? null : () => _setRead(plan.id, true),
                              icon: const Icon(Icons.check),
                              label: Text("reading_plan_article_mark".i18n([a.points.toString()])),
                            ),
                    ),
                    if (!plan.open)
                      Padding(
                        padding: EdgeInsets.only(top: 4.sp),
                        child: Text(
                          "reading_plan_closed_hint".i18n(),
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                        ),
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
