import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bible/data/api/bible_annotation_api.dart';
import 'package:work_hu/features/bible/data/model/bible_annotation.dart';

final bibleAnnotationApiProvider = Provider<BibleAnnotationApi>((ref) => BibleAnnotationApi());

/// Where an annotation is made: the translation, the chapter's numbering label in it, the book and chapter, and the
/// chapter's last verse in that translation (marks made in another numbering are placed by [shownRange]).
class BiblePlace {
  const BiblePlace({
    required this.translation,
    required this.numbering,
    required this.book,
    required this.chapter,
    this.lastVerse,
  });

  final String translation;
  final String numbering;
  final String book;
  final int chapter;
  final int? lastVerse;
}

/// The signed-in user's highlights, notes and bookmarks, by id. Kept on the device (per user, so nobody sees
/// another user's notes on a shared phone) and changed there at once; every change is queued and sent to the backend,
/// which also hands over what other devices changed. Offline, the queue waits for the next sync (on start and after
/// every change).
final bibleAnnotationsProvider = StateNotifierProvider<BibleAnnotationsNotifier, Map<String, BibleAnnotation>>((ref) {
  final userId = ref.watch(userDataProvider.select((u) => u.user?.id));
  return BibleAnnotationsNotifier(ref.read(bibleAnnotationApiProvider), userId?.toString());
});

class BibleAnnotationsNotifier extends StateNotifier<Map<String, BibleAnnotation>> {
  BibleAnnotationsNotifier(this._api, this._userId) : super(const {}) {
    if (_userId != null) _start();
  }

  final BibleAnnotationApi _api;
  final String? _userId;

  /// After this long without a sync, everything is asked for again (the backend forgets deletions after 90 days).
  static const fullSyncAfter = Duration(days: 60);

  /// The answers that mean the server will never take a change: it is dropped from the queue.
  static const refusedForGood = {400, 409, 413, 422};

  final Map<String, BibleAnnotation> _items = {};

  /// Changes not yet on the server, in order: id -> "put" or "delete".
  final Map<String, String> _pending = {};
  String? _next;
  DateTime? _lastSync;
  bool _syncing = false;
  bool _again = false;
  Future<void>? _loading;

  String get _key => 'bible_annotations_$_userId';

  Future<void> _start() async {
    _loading = _load();
    await _loading;
    await sync();
  }

  Future<void> _load() async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(_key);
      if (saved == null) return;
      final json = jsonDecode(saved) as Map<String, dynamic>;
      for (final a in json['items'] as List? ?? const []) {
        final annotation = BibleAnnotation.fromJson(a as Map<String, dynamic>);
        _items[annotation.id] = annotation;
      }
      (json['pending'] as Map<String, dynamic>? ?? const {}).forEach((id, op) => _pending[id] = op as String);
      _next = json['next'] as String?;
      _lastSync = DateTime.tryParse(json['lastSync'] as String? ?? '');
      if (mounted) state = Map.unmodifiable(_items);
    } catch (_) {
      // An unreadable copy: everything comes from the server again
    }
  }

  Future<void> _save() async {
    try {
      await (await SharedPreferences.getInstance()).setString(
        _key,
        jsonEncode({
          'items': [for (final a in _items.values) a.toJson()],
          'pending': _pending,
          'next': _next,
          'lastSync': _lastSync?.toIso8601String(),
        }),
      );
    } catch (_) {
      // Kept in memory; the server has what was sent
    }
  }

  void _changed() {
    if (mounted) state = Map.unmodifiable(_items);
    _save();
    sync();
  }

  /// Sends the queued changes, then takes over the server's changes. Several calls at once make one sync more.
  Future<void> sync() async {
    if (_userId == null) return;
    await _loading;
    if (_syncing) {
      _again = true;
      return;
    }
    _syncing = true;
    try {
      if (!await _push()) return;
      final full = _next == null || _lastSync == null || DateTime.now().difference(_lastSync!) > fullSyncAfter;
      final answer = await _api.getChanges(full ? null : _next);
      final incoming = [
        for (final a in answer['annotations'] as List? ?? const []) BibleAnnotation.fromJson(a as Map<String, dynamic>),
      ];
      if (full) {
        // What isn't on the server any more is gone, except what still waits to be sent
        _items.removeWhere((id, _) => !_pending.containsKey(id));
      }
      for (final a in incoming) {
        if (_pending.containsKey(a.id)) continue; // the change made here is newer
        if (a.deleted) {
          _items.remove(a.id);
        } else {
          _items[a.id] = a;
        }
      }
      _next = answer['next'] as String?;
      _lastSync = DateTime.now();
      if (mounted) state = Map.unmodifiable(_items);
    } catch (_) {
      // Offline or the server failed: the next sync tries again
    } finally {
      _syncing = false;
      await _save();
      if (_again && mounted) {
        _again = false;
        sync();
      }
    }
  }

  /// Sends the queue in order; false when the server could not be reached (the rest waits).
  Future<bool> _push() async {
    for (final entry in [..._pending.entries]) {
      try {
        if (entry.value == 'put') {
          final a = _items[entry.key];
          if (a != null) await _api.save(a.id, a.toJson());
        } else {
          await _api.delete(entry.key);
        }
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        // Refused for good (invalid, too many): dropped, the next full sync removes it here too. Anything else waits,
        // above all 404: a backend without these endpoints yet (the app released first) must not lose people's notes
        if (!refusedForGood.contains(status)) return false;
      }
      if (_pending[entry.key] == entry.value) _pending.remove(entry.key);
    }
    return true;
  }

  void _put(BibleAnnotation a) {
    _items[a.id] = a;
    _pending[a.id] = 'put';
  }

  void _delete(String id) {
    _items.remove(id);
    _pending[id] = 'delete';
  }

  /// The annotations of [type] shown on [verse] at [place], whatever numbering they were made in: what the buttons
  /// act on, so a mark made in another translation is changed rather than doubled.
  List<BibleAnnotation> shownAt(BiblePlace place, int verse, BibleAnnotationType type) => [
    for (final a in state.values)
      if (a.type == type && a.book == place.book && a.chapter == place.chapter)
        if (shownRange(a, place.numbering, lastVerse: place.lastVerse) case final r
            when verse >= r.start && verse <= r.end)
          a,
  ];

  BibleAnnotation _new(
    BiblePlace place,
    BibleAnnotationType type,
    int start,
    int end, {
    HighlightColor? color,
    String? note,
  }) {
    final now = DateTime.now().toUtc();
    return BibleAnnotation(
      id: const Uuid().v4(),
      type: type,
      translation: place.translation,
      numbering: place.numbering,
      book: place.book,
      chapter: place.chapter,
      verseStart: start,
      verseEnd: end,
      color: color,
      note: note,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Highlights each of [verses] with [color]; null takes their highlights away.
  void setHighlight(BiblePlace place, Iterable<int> verses, HighlightColor? color) {
    for (final verse in verses) {
      final mine = shownAt(place, verse, BibleAnnotationType.highlight);
      if (color == null) {
        for (final a in mine) {
          _delete(a.id);
        }
      } else if (mine.isEmpty) {
        _put(_new(place, BibleAnnotationType.highlight, verse, verse, color: color));
      } else {
        for (final a in mine) {
          _put(a.copyWith(color: color, updatedAt: DateTime.now().toUtc()));
        }
      }
    }
    _changed();
  }

  /// Saves a new note on verses [start]..[end], or changes the text of [existing].
  void saveNote(BiblePlace place, int start, int end, String text, {BibleAnnotation? existing}) {
    _put(
      existing?.copyWith(note: text, updatedAt: DateTime.now().toUtc()) ??
          _new(place, BibleAnnotationType.note, start, end, note: text),
    );
    _changed();
  }

  /// Sets a bookmark on [verse], or takes it away when there is one.
  void toggleBookmark(BiblePlace place, int verse) {
    final mine = shownAt(place, verse, BibleAnnotationType.bookmark);
    if (mine.isEmpty) {
      _put(_new(place, BibleAnnotationType.bookmark, verse, verse));
    } else {
      for (final a in mine) {
        _delete(a.id);
      }
    }
    _changed();
  }

  void delete(String id) {
    _delete(id);
    _changed();
  }
}
