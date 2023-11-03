import 'dart:convert';
import 'dart:math';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:pointycastle/export.dart";
import 'package:convert/convert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';

class Utils {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveData(String key, String value) async {
    try {
      var contains = await _storage.read(key: key);
      if (contains != null && contains.isNotEmpty) {
        await _storage.delete(key: key);
      }
      await _storage.write(key: key, value: value);
    } catch (e) {
      // log('Failed to save last $key');
    }
  }

  static Future<String> getData(String key) async {
    try {
      var data = await _storage.read(key: key);
      return data ?? '';
    } catch (e) {
      // log('Failed to pages outsource $key');
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
    var digested = d.process(dataToDigest);
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

  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }

  static String getTransactionTypeText(TransactionType transactionType, [bool long = true]) {
    if (transactionType == TransactionType.POINT) {
      return long ? "Points" : "p";
    } else if (transactionType == TransactionType.HOURS) {
      return long ? "Hours" : "h";
    } else if (transactionType == TransactionType.CREDIT) {
      return long ? "Credits" : "Ft";
    }
    return "";
  }

  static final NumberFormat creditFormat = NumberFormat("#,###");
  static final NumberFormat percentFormat = NumberFormat("#,###.#");

  static String dateToString(DateTime date){
    return "${date.year}-${date.month}-${date.day}";
  }
}
