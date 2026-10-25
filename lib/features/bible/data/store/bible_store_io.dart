import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'bible_store.dart';

BibleStore createBibleStore() => FileBibleStore();

/// One gzipped file per translation (`<id>.json.gz`, about 1.4 MB) and its version (`<id>.version`) in the app's
/// support folder, which is kept until the app is removed.
class FileBibleStore implements BibleStore {
  FileBibleStore([this._folder]);

  Directory? _folder;

  Future<Directory> _dir() async =>
      _folder ??= await Directory('${(await getApplicationSupportDirectory()).path}/bible').create(recursive: true);

  @override
  Future<({Uint8List json, String? version})?> load(String id) async {
    final dir = await _dir();
    final text = File('${dir.path}/$id.json.gz');
    if (!await text.exists()) return null;
    final version = File('${dir.path}/$id.version');
    return (
      json: Uint8List.fromList(gzip.decode(await text.readAsBytes())),
      version: await version.exists() ? (await version.readAsString()).trim() : null,
    );
  }

  @override
  Future<void> save(String id, Uint8List json, String? version) async {
    final dir = await _dir();
    // Written under a temporary name first, so an interrupted save never leaves half a file behind
    final temp = File('${dir.path}/$id.json.gz.part');
    await temp.writeAsBytes(gzip.encode(json), flush: true);
    await temp.rename('${dir.path}/$id.json.gz');
    await File('${dir.path}/$id.version').writeAsString(version ?? '');
  }

  @override
  Future<Set<String>> downloaded() async {
    final dir = await _dir();
    return {
      await for (final f in dir.list())
        if (f.path.endsWith('.json.gz')) f.uri.pathSegments.last.replaceFirst('.json.gz', ''),
    };
  }
}
