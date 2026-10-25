import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/providers/locale_provider.dart';
import 'package:work_hu/features/bible/data/api/bible_api.dart';
import 'package:work_hu/features/bible/data/model/bible_model.dart';
import 'package:work_hu/features/bible/data/repository/bible_repository.dart';
import 'package:work_hu/features/bible/data/store/bible_store.dart';
import 'package:work_hu/features/reading_plan/data/model/bible_translation.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart' show bibleChoiceProvider;

final bibleRepoProvider = Provider<BibleRepository>((ref) => BibleRepository(BibleApi(), BibleStore()));

const _translationsKey = 'bible_translations';

/// The translations the backend offers. Remembered, so the list is there offline too; without any answer yet it is
/// the translations bundled for the psalms (same ids).
final bibleTranslationsProvider = FutureProvider<List<BibleTranslationInfo>>((ref) async {
  try {
    final list = await ref.read(bibleRepoProvider).getTranslations();
    try {
      await (await SharedPreferences.getInstance()).setString(
        _translationsKey,
        jsonEncode([for (final t in list) t.toJson()]),
      );
    } catch (_) {
      // Only the offline list is missing then
    }
    return list;
  } catch (_) {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(_translationsKey);
      if (saved != null) {
        return [for (final t in jsonDecode(saved) as List) BibleTranslationInfo.fromJson(t as Map<String, dynamic>)];
      }
    } catch (_) {
      // Fall back to the bundled list
    }
    return [
      for (final t in bibleTranslations)
        BibleTranslationInfo(id: t.id, shortName: t.shortName, name: t.name, language: t.languageCode),
    ];
  }
});

/// The translation the Bible reader shows: the one picked in the reader (shared with the psalm reader), else the
/// first one in the app's language.
final bibleTranslationIdProvider = Provider<String>((ref) {
  final choice = ref.watch(bibleChoiceProvider);
  if (choice != null) return choice;
  return defaultTranslationFor(ref.watch(localeProvider).value?.languageCode).id;
});

/// The ids of the translations kept on the device.
final bibleDownloadedProvider = FutureProvider.autoDispose<Set<String>>(
  (ref) => ref.read(bibleRepoProvider).downloaded(),
);

class BibleTextState {
  const BibleTextState({this.bible, this.downloading = false, this.failed = false});

  final Bible? bible;
  final bool downloading;

  /// The translation isn't on the device and could not be downloaded.
  final bool failed;
}

/// One translation's text: the copy on the device at once, downloaded when there is none, and downloaded again in
/// the background when the backend has a newer version (the copy on the device is used until then, and when
/// offline). Kept in memory for two minutes after the last screen using it closes.
final bibleTextProvider = StateNotifierProvider.autoDispose.family<BibleTextNotifier, BibleTextState, String>((
  ref,
  id,
) {
  final link = ref.keepAlive();
  Timer? timer;
  ref.onCancel(() => timer = Timer(const Duration(minutes: 2), link.close));
  ref.onResume(() => timer?.cancel());
  ref.onDispose(() => timer?.cancel());
  return BibleTextNotifier(ref, id);
});

class BibleTextNotifier extends StateNotifier<BibleTextState> {
  BibleTextNotifier(this._ref, this.id) : super(const BibleTextState()) {
    _load();
  }

  final Ref _ref;
  final String id;

  BibleRepository get _repo => _ref.read(bibleRepoProvider);

  Future<void> _load() async {
    ({Bible bible, String? version})? local;
    try {
      local = await _repo.loadLocal(id);
    } catch (_) {
      // An unreadable copy is downloaded again
    }
    if (!mounted) return;
    if (local != null) state = BibleTextState(bible: local.bible);

    BibleTranslationInfo? info;
    try {
      final list = await _ref.read(bibleTranslationsProvider.future);
      info = list.where((t) => t.id == id).firstOrNull;
    } catch (_) {
      // Without the list the copy on the device is used as it is
    }
    if (!mounted) return;
    if (local != null && (info?.version == null || info!.version == local.version)) return;
    await _download(info?.version, quiet: local != null);
  }

  Future<void> _download(String? version, {required bool quiet}) async {
    if (!quiet) state = const BibleTextState(downloading: true);
    try {
      final bible = await _repo.download(id, version);
      if (!mounted) return;
      state = BibleTextState(bible: bible);
      _ref.invalidate(bibleDownloadedProvider);
    } catch (_) {
      // A failed update keeps the copy on the device
      if (mounted && !quiet) state = const BibleTextState(failed: true);
    }
  }

  Future<void> retry() => _load();
}

/// The translation read side by side with the active one, or null when parallel reading is off. Remembered.
final bibleParallelChoiceProvider = StateNotifierProvider<BibleParallelNotifier, String?>(
  (ref) => BibleParallelNotifier(),
);

/// The second column's translation: null when parallel reading is off or it is the same as the active one.
final bibleParallelIdProvider = Provider<String?>((ref) {
  final second = ref.watch(bibleParallelChoiceProvider);
  return second == ref.watch(bibleTranslationIdProvider) ? null : second;
});

class BibleParallelNotifier extends StateNotifier<String?> {
  BibleParallelNotifier() : super(null) {
    _load();
  }

  static const _key = 'bible_parallel';
  bool _picked = false;

  Future<void> _load() async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(_key);
      if (mounted && !_picked && saved != null && saved.isNotEmpty) state = saved;
    } catch (_) {
      // Parallel reading starts off then
    }
  }

  /// [id] null switches parallel reading off.
  Future<void> select(String? id) async {
    _picked = true;
    state = id;
    try {
      await (await SharedPreferences.getInstance()).setString(_key, id ?? '');
    } catch (_) {
      // Not remembered, still used for now
    }
  }
}

/// The book whose chapters the Bible page shows (OSIS code), or null for the book grid.
final bibleSelectedBookProvider = StateProvider<String?>((ref) => null);

/// The chapter of [bibleSelectedBookProvider] whose verses the Bible page shows, or null for the chapter grid.
final bibleSelectedChapterProvider = StateProvider<int?>((ref) => null);

/// Where the reader was last: shown as "Continue" on the Bible page. Remembered.
final biblePositionProvider = StateNotifierProvider<BiblePositionNotifier, BiblePosition?>(
  (ref) => BiblePositionNotifier(),
);

class BiblePositionNotifier extends StateNotifier<BiblePosition?> {
  BiblePositionNotifier() : super(null) {
    _load();
  }

  static const _key = 'bible_position';
  static const _labelKey = 'bible_position_label';

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = BiblePosition.decode(prefs.getString(_key));
      if (mounted && saved != null && state == null) {
        state = BiblePosition(saved.osis, saved.chapter, label: prefs.getString(_labelKey));
      }
    } catch (_) {
      // No "Continue" then
    }
  }

  Future<void> set(BiblePosition position) async {
    if (state == position && state?.label == position.label) return;
    state = position;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, position.encode());
      if (position.label != null) await prefs.setString(_labelKey, position.label!);
    } catch (_) {
      // Not remembered, still shown for now
    }
  }
}
