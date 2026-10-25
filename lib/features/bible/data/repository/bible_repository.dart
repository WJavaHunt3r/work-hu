import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:work_hu/features/bible/data/api/bible_api.dart';
import 'package:work_hu/features/bible/data/model/bible_model.dart';
import 'package:work_hu/features/bible/data/store/bible_store.dart';

/// Reads a translation's JSON; run in a background isolate, the text is about 5 MB.
Bible parseBible(Uint8List json) => Bible.fromJson(jsonDecode(utf8.decode(json)) as Map<String, dynamic>);

Future<Bible> _parseInBackground(Uint8List json) => compute(parseBible, json);

class BibleRepository {
  /// [parse] reads the JSON in a background isolate; tests pass a plain function.
  BibleRepository(this._api, this._store, {Future<Bible> Function(Uint8List json)? parse})
    : _parse = parse ?? _parseInBackground;

  final BibleApi _api;
  final BibleStore _store;
  final Future<Bible> Function(Uint8List json) _parse;

  Future<List<BibleTranslationInfo>> getTranslations() async => [
    for (final t in await _api.getTranslations()) BibleTranslationInfo.fromJson(t as Map<String, dynamic>),
  ];

  /// The downloaded copy and its version, or null when the translation isn't downloaded.
  Future<({Bible bible, String? version})?> loadLocal(String id) async {
    final stored = await _store.load(id);
    if (stored == null) return null;
    return (bible: await _parse(stored.json), version: stored.version);
  }

  /// Downloads the translation and keeps it (only once it could be read, so a broken download is never kept).
  Future<Bible> download(String id, String? version) async {
    final json = await _api.getText(id);
    final bible = await _parse(json);
    await _store.save(id, json, version);
    return bible;
  }

  Future<Set<String>> downloaded() => _store.downloaded();
}
