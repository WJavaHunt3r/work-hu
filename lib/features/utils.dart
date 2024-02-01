import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import "package:pointycastle/export.dart";
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';

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

  static String encrypt(String raw) {
    var dataToDigest = createUInt8ListFromString(raw);
    var d = Digest('SHA-256');
    var digested = d.process(dataToDigest);
    var hexa = hex.encode(digested);
    return base64.encode(hexa.codeUnits);
  }

  static Uint8List createUInt8ListFromString(String s) {
    var ret = Uint8List(s.length);
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

  static final NumberFormat creditFormat = NumberFormat("# ###");
  static final NumberFormat percentFormat = NumberFormat("# ###.#");

  static String dateToString(DateTime date) {
    return "${date.year}-${date.month < 10 ? "0${date.month}" : date.month}-${date.day < 10 ? "0${date.day}" : date.day}";
  }

  static RoundModel createEmptyRound() {
    return RoundModel(
        id: 0,
        roundNumber: 0,
        samvirkGoal: 0,
        myShareGoal: 0,
        samvirkChurchGoal: 0,
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        season: SeasonModel(
          id: 0,
          seasonYear: DateTime.now().year,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        ));
  }

  static String changeHunChars(String text) {
    for (String entry in getEngChar().keys) {
      text = text.replaceAll(entry, getEngChar()[entry] ?? "");
    }
    return text;
  }

  static Map<String, String> getEngChar() {
    return <String, String>{
      "ö": "o",
      "ü": "u",
      "ó": "o",
      "ő": "o",
      "ú": "u",
      "ű": "u",
      "é": "e",
      "á": "a",
      "í": "i",
    };
  }
}
