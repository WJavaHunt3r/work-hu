import 'dart:typed_data';

import 'bible_store.dart';

BibleStore createBibleStore() => MemoryBibleStore();

/// Keeps translations for as long as the app runs (the web; tests).
class MemoryBibleStore implements BibleStore {
  final _texts = <String, ({Uint8List json, String? version})>{};

  @override
  Future<({Uint8List json, String? version})?> load(String id) async => _texts[id];

  @override
  Future<void> save(String id, Uint8List json, String? version) async => _texts[id] = (json: json, version: version);

  @override
  Future<Set<String>> downloaded() async => _texts.keys.toSet();
}
