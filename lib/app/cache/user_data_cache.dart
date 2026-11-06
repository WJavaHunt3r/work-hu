import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What the signed-in user saw last time (their user data, balance, status, the Jobs tab), so a start shows it at
/// once and the screens refresh it from the API in the background (stale-while-revalidate).
///
/// One user at a time, as one JSON entry in SharedPreferences (`user_data_cache`: the user's id and the entries by
/// name). Opening it for another user deletes the previous user's entries, logout deletes it. Never put tokens or
/// anything else secret here: SharedPreferences is plain storage (localStorage on the web).
///
/// [UserProvider.initUser] loads it before the app is first drawn, so notifiers read it synchronously when they are
/// created ([read]) and write what the API answered ([write]).
class UserDataCache {
  UserDataCache._();

  static final UserDataCache instance = UserDataCache._();

  static const _key = 'user_data_cache';

  /// Entry names.
  static const user = 'user';
  static const balance = 'balance';
  static const status = 'status';
  static const jobs = 'jobs';

  num? _userId;
  Map<String, dynamic> _entries = {};

  /// The user whose data is in memory; null when nothing is open.
  num? get userId => _userId;

  /// Loads what is stored, whoever it belongs to (the start, before the user is known). Returns the stored user's
  /// id, or null when nothing is stored.
  Future<num?> load() async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(_key);
      if (saved != null && saved.isNotEmpty) {
        final json = jsonDecode(saved) as Map<String, dynamic>;
        _userId = json['userId'] as num?;
        _entries = Map<String, dynamic>.from(json['entries'] as Map? ?? const {});
        return _userId;
      }
    } catch (_) {
      // A broken entry is as good as none
    }
    _userId = null;
    _entries = {};
    return null;
  }

  /// Makes [userId] the owner: keeps what is in memory or stored for them, deletes another user's entries.
  Future<void> open(num userId) async {
    if (_userId == null) await load();
    if (_userId == userId) return;
    _userId = userId;
    _entries = {};
    await _persist();
  }

  /// The entry [name] of [userId] as plain JSON (maps, lists), or null when there is none or it belongs to someone
  /// else.
  dynamic read(num? userId, String name) => userId != null && userId == _userId ? _entries[name] : null;

  /// The entry [name] of [userId] read with [fromJson]; null when there is none or it no longer parses (an older app
  /// version's shape).
  T? parse<T>(num? userId, String name, T Function(Map<String, dynamic> json) fromJson) {
    final json = read(userId, name);
    if (json is! Map<String, dynamic>) return null;
    try {
      return fromJson(json);
    } catch (e) {
      debugPrint('Cached $name not usable: $e');
      return null;
    }
  }

  /// Stores [value] (anything `jsonEncode` takes, e.g. freezed models) as the entry [name] of [userId]. Ignored when
  /// [userId] is not the owner, e.g. a slow request of the previous user answering after a user change.
  Future<void> write(num? userId, String name, Object? value) async {
    if (userId == null || userId != _userId) return;
    try {
      _entries[name] = jsonDecode(jsonEncode(value));
    } catch (e) {
      debugPrint('Could not cache $name: $e');
      return;
    }
    await _persist();
  }

  /// Deletes everything (logout).
  Future<void> clear() async {
    _userId = null;
    _entries = {};
    try {
      await (await SharedPreferences.getInstance()).remove(_key);
    } catch (_) {
      // Nothing stored or no storage
    }
  }

  Future<void> _persist() async {
    final userId = _userId;
    if (userId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      // Logout or a user change came in meanwhile
      if (_userId != userId) return;
      await prefs.setString(_key, jsonEncode({'userId': userId, 'entries': _entries}));
    } catch (_) {
      // Only the next start is slower then
    }
  }
}
