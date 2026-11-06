import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// True when [error] means the server could not be reached or failed for now (no answer, a timeout, a 5xx): the
/// copy on the device is shown and changes wait. An answer that refuses something (4xx) is not "offline".
bool isOfflineError(Object error) {
  if (error is! DioException) return false;
  final status = error.response?.statusCode;
  return status == null || status >= 500;
}

/// The reading plan's last answers (plan, articles, ranking) and the marks not yet sent, per user, in
/// SharedPreferences, so the psalms open offline. Keys start with `reading_plan_<userId>_`, so nobody sees another
/// user's progress on a shared phone.
class ReadingPlanCache {
  const ReadingPlanCache();

  static String _key(String user, String name) => 'reading_plan_${user}_$name';

  /// The JSON answer saved under [name], or null when there is none (`hasValue` false). An answer that was null
  /// itself (no plan) is kept as such.
  Future<({bool hasValue, Object? json})> read(String user, String name) async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(_key(user, name));
      if (saved != null) return (hasValue: true, json: jsonDecode(saved));
    } catch (_) {
      // An unreadable copy counts as none
    }
    return (hasValue: false, json: null);
  }

  Future<void> write(String user, String name, Object? json) async {
    try {
      await (await SharedPreferences.getInstance()).setString(_key(user, name), jsonEncode(json));
    } catch (_) {
      // Only the offline copy is missing then
    }
  }

  /// The marks made but not yet on the server: "planId:item" -> read (true) or taken back (false). The backend's
  /// mark and unmark are idempotent, so only the last change per item counts.
  Future<Map<String, bool>> pending(String user) async {
    final saved = await read(user, 'pending');
    final json = saved.json;
    if (json is! Map) return {};
    return {for (final e in json.entries) e.key as String: e.value == true};
  }

  Future<void> setPending(String user, Map<String, bool> pending) => write(user, 'pending', pending);
}
