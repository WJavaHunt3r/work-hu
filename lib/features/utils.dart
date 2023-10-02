import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import "package:pointycastle/export.dart";
import 'package:convert/convert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Utils{
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveData(String key, String value) async {
    try {
      var contains = await _storage.read(key: key);
      if (contains != null && contains.isNotEmpty) {
        await _storage.delete(key: key);
      }
      await _storage.write(key: key, value: value);
    } catch (e) {
      log('Failed to save last $key');
    }
  }

  static Future<String> getData(String key) async {
    try {
      var data = await _storage.read(key: key);
      return data ?? '';
    } catch (e) {
      log('Failed to pages outsource $key');
      return '';
    }
  }

  static String encodeHashToBase64(String secretHash) {
    final base64String = base64.encode(secretHash.codeUnits);
    return base64String.replaceAll('=', ''); // Remove padding
  }

  /// Hash method with [SHA256]
  static String encrypt(String raw) {
    var dataToDigest = createUint8ListFromString(raw);
    var d = Digest('SHA-256');
    var digested =d.process(dataToDigest);
    var hexa = hex.encode(digested);
    return base64.encode(hexa.codeUnits);
  }

  static Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }
}