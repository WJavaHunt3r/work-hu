import 'package:flutter/services.dart';

/// Saves a file into the phone's Downloads folder with an explicit type (Android only; `MainActivity.saveToDownloads`).
/// Used instead of file_saver's "save as" dialog: Android registers a .csv saved that way as
/// `text/comma-separated-values`, and file pickers asking for `text/csv` (the MyShare import) grey it out.
class AndroidDownloads {
  static const _channel = MethodChannel('dukapp/downloads');

  /// Returns the name the file got (Android adds " (1)" when the name is taken).
  static Future<String> save({required String name, required String mimeType, required Uint8List bytes}) async {
    final saved = await _channel.invokeMethod<String>('save', {'name': name, 'mimeType': mimeType, 'bytes': bytes});
    return saved ?? name;
  }
}
