import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/providers/locale_provider.dart';
import 'package:work_hu/features/reading_plan/data/api/reading_plan_api.dart';
import 'package:work_hu/features/reading_plan/data/model/bible_translation.dart';
import 'package:work_hu/features/reading_plan/data/model/reading_plan_model.dart';
import 'package:work_hu/features/reading_plan/data/repository/reading_plan_repository.dart';

final readingPlanRepoProvider = Provider<ReadingPlanRepository>((ref) => ReadingPlanRepository(ReadingPlanApi()));

class ReadingPlanState {
  const ReadingPlanState({this.plan, this.loading = false, this.error});

  /// Null while loading, on an error, or when there is no plan.
  final ReadingPlanModel? plan;
  final bool loading;
  final String? error;
}

/// The current reading plan with the user's progress, in the app's language. Only users with the READING_PLAN
/// permission get one (the server refuses the others), so without it nothing is requested and there is no plan.
/// Marking is optimistic: the item changes at once and goes back (with the reason shown) if the server refuses.
final readingPlanProvider = StateNotifierProvider.autoDispose<ReadingPlanNotifier, ReadingPlanState>((ref) {
  final user = ref.watch(userDataProvider).user;
  // People who manage the plan (write its articles) must see it too
  final allowed =
      user != null &&
      (user.hasPermission(Permission.READING_PLAN) || user.hasPermission(Permission.READING_PLAN_MANAGE));
  // Wait for the app language: asking before it is known would show the default language for a moment
  final locale = ref.watch(localeProvider);
  if (allowed && !locale.hasValue) return ReadingPlanNotifier.waiting(ref.read(readingPlanRepoProvider));
  return ReadingPlanNotifier(ref.read(readingPlanRepoProvider), locale.value?.languageCode ?? 'hu', enabled: allowed);
});

class ReadingPlanNotifier extends StateNotifier<ReadingPlanState> {
  ReadingPlanNotifier(this._repo, this._language, {bool enabled = true})
    : super(enabled ? const ReadingPlanState(loading: true) : const ReadingPlanState()) {
    if (enabled) {
      load();
    } else {
      _firstLoad.complete();
    }
  }

  /// Shows "loading" without asking the server yet (the app language is not known). The provider is rebuilt when it is.
  ReadingPlanNotifier.waiting(this._repo) : _language = 'hu', super(const ReadingPlanState(loading: true));

  /// Completes when the plan has been loaded for the first time (or failed to), for pages opened directly that need it.
  final _firstLoad = Completer<void>();
  Future<void> get firstLoad => _firstLoad.future;

  @override
  void dispose() {
    // A waiting notifier is replaced when the app language is known: let whoever waits on it ask the new one
    if (!_firstLoad.isCompleted) _firstLoad.complete();
    super.dispose();
  }

  final ReadingPlanRepository _repo;
  final String _language;

  /// Requests in flight: the server's answer only replaces the items when the last one is back, so answers arriving
  /// out of order can't make an item flicker.
  int _pending = 0;

  Future<void> load() async {
    try {
      final plan = await _repo.getCurrent(_language);
      if (mounted) state = ReadingPlanState(plan: plan);
    } on ApiException catch (e) {
      if (mounted) state = ReadingPlanState(error: e.message);
    } catch (_) {
      if (mounted) state = ReadingPlanState(error: "api_unknown_error".i18n());
    } finally {
      if (!_firstLoad.isCompleted) _firstLoad.complete();
    }
  }

  Future<void> setRead(int item, {required bool read}) async {
    final plan = state.plan;
    if (plan == null || !plan.open) return;
    final before = plan.myItems;
    final optimistic = {...before};
    read ? optimistic.add(item) : optimistic.remove(item);
    state = ReadingPlanState(plan: plan.withItems(optimistic));
    _pending++;
    try {
      final items = await _repo.setRead(plan.id, item, read: read);
      _pending--;
      if (mounted && _pending == 0 && state.plan != null) state = ReadingPlanState(plan: state.plan!.withItems(items));
    } on ApiException catch (e) {
      _pending--;
      _revert(item, before);
      showApiError(e.message);
    } catch (_) {
      _pending--;
      _revert(item, before);
      showApiError("api_unknown_error".i18n());
    }
  }

  void _revert(int item, Set<int> before) {
    final plan = state.plan;
    if (!mounted || plan == null) return;
    final items = {...plan.myItems};
    before.contains(item) ? items.add(item) : items.remove(item);
    state = ReadingPlanState(plan: plan.withItems(items));
  }
}

/// The ranking of a plan (first 100 people) and where the user stands.
final leaderboardProvider = FutureProvider.autoDispose.family<LeaderboardModel, num>(
  (ref, planId) => ref.read(readingPlanRepoProvider).getLeaderboard(planId),
);

/// The app's language code ("hu", "en"), which picks the translation of plan texts and articles.
final appLanguageProvider = Provider<String>((ref) => ref.watch(localeProvider).value?.languageCode ?? 'hu');

/// The articles of a plan for readers (published ones), newest first, without their text.
final articlesProvider = FutureProvider.autoDispose.family<List<ReadingArticle>, num>(
  (ref, planId) async =>
      ref.read(readingPlanRepoProvider).getArticles(planId, (await ref.watch(localeProvider.future)).languageCode),
);

/// One article with its text, for reading.
final articleProvider = FutureProvider.autoDispose.family<ReadingArticle, ({num planId, num id})>(
  (ref, key) async => ref
      .read(readingPlanRepoProvider)
      .getArticle(key.planId, key.id, (await ref.watch(localeProvider.future)).languageCode),
);

/// All articles of a plan including drafts, for the admin page.
final adminArticlesProvider = FutureProvider.autoDispose.family<List<ReadingArticle>, num>(
  (ref, planId) => ref.read(readingPlanRepoProvider).getAllArticles(planId),
);

/// The text of one bundled translation of the Psalms, by psalm number. Read from the app's assets once per
/// translation, so reading works offline.
final psalmTextProvider = FutureProvider.family<Map<int, List<Verse>>, String>((ref, translationId) async {
  final asset = translationById(translationId).asset;
  final json = jsonDecode(await rootBundle.loadString(asset)) as Map<String, dynamic>;
  return {
    for (final chapter in json['chapters'] as List)
      (chapter['chapter'] as num).toInt(): [
        for (final v in chapter['verses'] as List) Verse((v['number'] as num).toInt(), v['text'] as String),
      ],
  };
});

/// The translation the user picked in the reader, or null while they follow the app language. Remembered.
final bibleChoiceProvider = StateNotifierProvider<BibleChoiceNotifier, String?>((ref) => BibleChoiceNotifier());

class BibleChoiceNotifier extends StateNotifier<String?> {
  BibleChoiceNotifier() : super(null) {
    _load();
  }

  static const _key = 'bible_translation';

  Future<void> _load() async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(_key);
      if (mounted && saved != null) state = saved;
    } catch (_) {
      // Without the remembered choice the app language decides
    }
  }

  Future<void> select(String id) async {
    state = id;
    try {
      await (await SharedPreferences.getInstance()).setString(_key, id);
    } catch (_) {
      // Not remembered, still used for now
    }
  }
}

/// The translation the reader shows: the user's pick, else the first one in the app's language.
final activeTranslationProvider = Provider<BibleTranslation>((ref) {
  final choice = ref.watch(bibleChoiceProvider);
  if (choice != null) return translationById(choice);
  return defaultTranslationFor(ref.watch(localeProvider).value?.languageCode);
});
