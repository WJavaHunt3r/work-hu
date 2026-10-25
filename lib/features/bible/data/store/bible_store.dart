import 'dart:typed_data';

import 'bible_store_memory.dart' if (dart.library.io) 'bible_store_io.dart' as platform;

/// Where downloaded translations are kept: files on the phone (offline reading), memory on the web (the browser's
/// HTTP cache keeps the download there). The text is the JSON exactly as downloaded.
abstract class BibleStore {
  factory BibleStore() => platform.createBibleStore();

  /// The stored text and the version it was downloaded at, or null when the translation isn't downloaded.
  Future<({Uint8List json, String? version})?> load(String id);

  Future<void> save(String id, Uint8List json, String? version);

  /// The ids of the downloaded translations.
  Future<Set<String>> downloaded();
}
