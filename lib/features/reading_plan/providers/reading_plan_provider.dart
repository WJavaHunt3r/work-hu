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
import 'package:work_hu/features/reading_plan/data/store/reading_plan_cache.dart';

final readingPlanRepoProvider = Provider<ReadingPlanRepository>((ref) => ReadingPlanRepository(ReadingPlanApi()));

class ReadingPlanState {
  const ReadingPlanState({this.plan, this.loading = false, this.error, this.offline = false, this.unsent = 0});

  /// Null while loading, on an error, or when there is no plan.
  final ReadingPlanModel? plan;
  final bool loading;
  final String? error;

  /// The server could not be reached: [plan] is the copy kept on the device.
  final bool offline;

  /// Marks made here that the server doesn't have yet.
  final int unsent;
}

/// The current reading plan with the user's progress, in the app's language. Only users with the READING_PLAN
/// permission get one (the server refuses the others), so without it nothing is requested and there is no plan.
/// Marking is optimistic: the item changes at once and goes back (with the reason shown) if the server refuses.
/// Works offline: the last answer is kept per user and shown at once, marks made without a connection are queued
/// (on the device) and sent before the plan is asked for again, which is tried every [ReadingPlanNotifier.retryAfter]
/// while offline.
final readingPlanProvider = StateNotifierProvider.autoDispose<ReadingPlanNotifier, ReadingPlanState>((ref) {
  final user = ref.watch(userDataProvider).user;
  // People who manage the plan (write its articles) must see it too
  final allowed =
      user != null &&
      (user.hasPermission(Permission.READING_PLAN) || user.hasPermission(Permission.READING_PLAN_MANAGE));
  // Wait for the app language: asking before it is known would show the default language for a moment
  final locale = ref.watch(localeProvider);
  if (allowed && !locale.hasValue) return ReadingPlanNotifier.waiting(ref.read(readingPlanRepoProvider));
  return ReadingPlanNotifier(
    ref.read(readingPlanRepoProvider),
    locale.value?.languageCode ?? 'hu',
    user: user?.id.toString(),
    enabled: allowed,
  );
});

class ReadingPlanNotifier extends StateNotifier<ReadingPlanState> {
  ReadingPlanNotifier(this._repo, this._language, {String? user, bool enabled = true})
    : _user = user,
      super(enabled ? const ReadingPlanState(loading: true) : const ReadingPlanState()) {
    if (enabled) {
      load();
    } else {
      _firstLoad.complete();
    }
  }

  /// Shows "loading" without asking the server yet (the app language is not known). The provider is rebuilt when it is.
  ReadingPlanNotifier.waiting(this._repo)
    : _language = 'hu',
      _user = null,
      super(const ReadingPlanState(loading: true));

  /// How long to wait before trying again while offline.
  static const retryAfter = Duration(seconds: 30);

  /// Completes when the plan has been loaded for the first time (or failed to), for pages opened directly that need it.
  final _firstLoad = Completer<void>();
  Future<void> get firstLoad => _firstLoad.future;

  @override
  void dispose() {
    _retry?.cancel();
    // A waiting notifier is replaced when the app language is known: let whoever waits on it ask the new one
    if (!_firstLoad.isCompleted) _firstLoad.complete();
    super.dispose();
  }

  final ReadingPlanRepository _repo;
  final String _language;

  /// Whose copy is kept on the device; null keeps nothing.
  final String? _user;

  /// Requests in flight: the server's answer only replaces the items when the last one is back, so answers arriving
  /// out of order can't make an item flicker.
  int _pending = 0;

  /// Marks not yet on the server ("planId:item" -> read), as kept on the device.
  Map<String, bool> _unsent = {};
  Timer? _retry;

  static String _unsentKey(num planId, int item) => '$planId:$item';

  /// [items] with the marks not yet on the server applied.
  Set<int> _withUnsent(ReadingPlanModel plan, Set<int> items) {
    final result = {...items};
    _unsent.forEach((key, read) {
      final parts = key.split(':');
      if (parts.length != 2 || parts[0] != plan.id.toString()) return;
      final item = int.tryParse(parts[1]);
      if (item == null) return;
      read ? result.add(item) : result.remove(item);
    });
    return result;
  }

  ReadingPlanModel? _shown(ReadingPlanModel? plan) => plan?.withItems(_withUnsent(plan, plan.myItems));

  void _show(ReadingPlanModel? plan, {required bool offline}) {
    if (!mounted) return;
    state = ReadingPlanState(plan: _shown(plan), offline: offline, unsent: _unsent.length);
  }

  void _offline() {
    if (!mounted) return;
    state = ReadingPlanState(plan: state.plan, error: state.error, offline: true, unsent: _unsent.length);
    _retry?.cancel();
    _retry = Timer(retryAfter, () {
      if (mounted) load();
    });
  }

  Future<void> load() async {
    _retry?.cancel();
    final user = _user;
    try {
      if (user != null) {
        _unsent = await _repo.cache.pending(user);
        // The copy on the device at once; the server's answer replaces it
        if (state.plan == null) {
          final saved = await _repo.savedCurrent(_language, user);
          if (saved != null && mounted && state.plan == null) _show(saved, offline: false);
        }
        await _sendUnsent(user);
      }
      final answer = await _repo.getCurrentCached(_language, user);
      if (answer.offline) {
        _show(answer.value, offline: true);
        _offline();
      } else {
        _show(answer.value, offline: false);
      }
    } on ApiException catch (e) {
      if (mounted) state = ReadingPlanState(error: e.message);
    } catch (e) {
      if (isOfflineError(e)) {
        if (mounted) {
          state = ReadingPlanState(
            plan: state.plan,
            error: state.plan == null ? "reading_plan_offline_none".i18n() : null,
            offline: true,
            unsent: _unsent.length,
          );
        }
        _offline();
      } else if (mounted) {
        state = ReadingPlanState(error: "api_unknown_error".i18n());
      }
    } finally {
      if (!_firstLoad.isCompleted) _firstLoad.complete();
    }
  }

  /// Sends the queued marks; stops at the first one the server can't be reached for (the rest waits). A mark the
  /// server refuses (e.g. the plan closed meanwhile) is dropped: the plan's next answer shows the real state.
  Future<void> _sendUnsent(String user) async {
    for (final entry in [..._unsent.entries]) {
      final parts = entry.key.split(':');
      final planId = num.tryParse(parts.first);
      final item = parts.length == 2 ? int.tryParse(parts[1]) : null;
      if (planId != null && item != null) {
        try {
          await _repo.setRead(planId, item, read: entry.value);
        } catch (e) {
          if (isOfflineError(e)) rethrow;
        }
      }
      if (_unsent[entry.key] == entry.value) _unsent.remove(entry.key);
      await _repo.cache.setPending(user, _unsent);
    }
  }

  Future<void> setRead(int item, {required bool read}) async {
    final plan = state.plan;
    if (plan == null || !plan.open) return;
    final before = plan.myItems;
    final optimistic = {...before};
    read ? optimistic.add(item) : optimistic.remove(item);
    final key = _unsentKey(plan.id, item);
    final user = _user;
    // Kept on the device until the server has it, so a mark made offline survives a restart
    _unsent[key] = read;
    if (user != null) await _repo.cache.setPending(user, _unsent);
    if (!mounted) return;
    state = ReadingPlanState(plan: plan.withItems(optimistic), offline: state.offline, unsent: _unsent.length);
    _pending++;
    try {
      final items = await _repo.setRead(plan.id, item, read: read);
      _pending--;
      await _sent(key, read);
      if (user != null) await _repo.saveItems(_language, user, items);
      if (mounted && _pending == 0 && state.plan != null) {
        state = ReadingPlanState(plan: state.plan!.withItems(_withUnsent(state.plan!, items)), unsent: _unsent.length);
        // Back online with marks still waiting from before: send them now
        if (_unsent.isNotEmpty) load();
      }
    } on ApiException catch (e) {
      _pending--;
      await _sent(key, read);
      _revert(item, before);
      showApiError(e.message);
    } catch (e) {
      _pending--;
      if (isOfflineError(e) && user != null) {
        // Stays marked; sent when the server can be reached again
        _offline();
        return;
      }
      await _sent(key, read);
      _revert(item, before);
      showApiError("api_unknown_error".i18n());
    }
  }

  /// The server answered for [key]: it no longer waits (unless it was changed again meanwhile).
  Future<void> _sent(String key, bool read) async {
    if (_unsent[key] != read) return;
    _unsent.remove(key);
    if (_user != null) await _repo.cache.setPending(_user, _unsent);
  }

  void _revert(int item, Set<int> before) {
    final plan = state.plan;
    if (!mounted || plan == null) return;
    final items = {...plan.myItems};
    before.contains(item) ? items.add(item) : items.remove(item);
    state = ReadingPlanState(plan: plan.withItems(items), offline: state.offline, unsent: _unsent.length);
  }
}

/// The ranking of a plan (first 100 people) and where the user stands. Members and guests are ranked apart; this is
/// the user's own group.
final leaderboardProvider = FutureProvider.autoDispose.family<LeaderboardModel, num>(
  (ref, planId) => ref.read(readingPlanRepoProvider).getLeaderboard(planId, user: ref.watch(_userKeyProvider)),
);

/// The ranking of one group ("members" or "guests"), which managers (READING_PLAN_MANAGE) can switch between.
final leaderboardOfGroupProvider = FutureProvider.autoDispose.family<LeaderboardModel, ({num planId, String group})>(
  (ref, key) =>
      ref.read(readingPlanRepoProvider).getLeaderboard(key.planId, user: ref.watch(_userKeyProvider), group: key.group),
);

/// Whose copies of the plan's answers are kept on the device (the signed-in user's id).
final _userKeyProvider = Provider<String?>((ref) => ref.watch(userDataProvider.select((u) => u.user?.id))?.toString());

/// The app's language code ("hu", "en"), which picks the translation of plan texts and articles.
final appLanguageProvider = Provider<String>((ref) => ref.watch(localeProvider).value?.languageCode ?? 'hu');

/// The articles of a plan for readers (published ones), newest first, without their text.
final articlesProvider = FutureProvider.autoDispose.family<List<ReadingArticle>, num>((ref, planId) async {
  final user = ref.watch(_userKeyProvider);
  return ref
      .read(readingPlanRepoProvider)
      .getArticles(planId, (await ref.watch(localeProvider.future)).languageCode, user: user);
});

/// One article with its text, for reading.
final articleProvider = FutureProvider.autoDispose.family<ReadingArticle, ({num planId, num id})>((ref, key) async {
  final user = ref.watch(_userKeyProvider);
  return ref
      .read(readingPlanRepoProvider)
      .getArticle(key.planId, key.id, (await ref.watch(localeProvider.future)).languageCode, user: user);
});

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
