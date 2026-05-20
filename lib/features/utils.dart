import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:pointycastle/api.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/widgets/error_dialog.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';

class Utils {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

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

  static String getTransactionTypeText(TransactionType? transactionType, [bool long = true]) {
    if (transactionType == TransactionType.POINT) {
      return long ? "base_text_points".i18n() : "base_text_points_short".i18n();
    } else if ([TransactionType.HOURS, TransactionType.DUKA_MUNKA, TransactionType.DUKA_MUNKA_2000].contains(transactionType)) {
      return long ? "base_text_hours".i18n() : "base_text_hours_short".i18n();
    } else if (transactionType == TransactionType.CREDIT) {
      return long ? "base_text_credits".i18n() : "base_text_credits_short".i18n();
    }
    return "";
  }

  static final NumberFormat creditFormat = NumberFormat("#,###", "hu_HU");
  static final NumberFormat percentFormat = NumberFormat.decimalPatternDigits(decimalDigits: 0, locale: "hu_HU");
  static final NumberFormat percentFormat2Digits = NumberFormat.decimalPatternDigits(decimalDigits: 2);

  static String creditFormatting(num number) {
    return "${creditFormat.format(number)} Ft";
  }

  static String percentFormatting(num number) {
    return "${percentFormat.format(number)} %";
  }

  static String dateToString(DateTime date) {
    return "${date.year}-${date.month < 10 ? "0${date.month}" : date.month}-${date.day < 10 ? "0${date.day}" : date.day}";
  }

  static String dateTimeToDateOnlyString(DateTime? date) {
    if(date == null) return "";
    return DateFormat("yyyy-MM-dd").format(date);
  }

  static String dateToStringWithDots(DateTime date) {
    return "${date.year}.${date.month < 10 ? "0${date.month}" : date.month}.${date.day < 10 ? "0${date.day}" : date.day}";
  }

  static String dateToTimeString(DateTime date) {
    return "${date.hour < 10 ? "0${date.hour}" : date.hour}:${date.minute < 10 ? "0${date.minute}" : date.minute}:${date.second < 10 ? "0${date.second}" : date.second}";
  }

  static String dateToStringUnformatted(DateTime date) {
    return "${date.year}${date.month < 10 ? "0${date.month}" : date.month}${date.day < 10 ? "0${date.day}" : date.day}";
  }

  static String dateToStringWithTime(DateTime date) {
    return "${date.year}-${date.month < 10 ? "0${date.month}" : date.month}-${date.day < 10 ? "0${date.day}" : date.day} ${date.hour < 10 ? "0${date.hour}" : date.hour}:${date.minute < 10 ? "0${date.minute}" : date.minute}";
  }

  static String dateFormating(DateTime? date, [String? locale]){
    if(date == null) return "";
    return DateFormat('yyyy. MMM dd.', locale).format(date);
  }

  static String dateFormatingWithTime(DateTime? date, [String? locale]){
    if(date == null) return "";
    return DateFormat('yyyy. MMM dd. • HH:mm', locale).format(date);
  }

  // static RoundModel createEmptyRound() {
  //   return RoundModel(
  //       id: 0,
  //       roundNumber: 0,
  //       samvirkGoal: 0,
  //       myShareGoal: 0,
  //       samvirkChurchGoal: 0,
  //       startDateTime: DateTime.now(),
  //       endDateTime: DateTime.now(),
  //       season: SeasonModel(
  //         id: 0,
  //         seasonYear: DateTime.now().year,
  //         startDate: DateTime.now(),
  //         endDate: DateTime.now(),
  //       ),
  //       freezeDateTime: DateTime.now(),
  //       activeRound: true);
  // }

  static String changeSpecChars(String text) {
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
      " ": "_",
      "/": "",
      "-": "_",
    };
  }

  static String createFileName(ActivityModel activity) {
    return "${dateToString(activity.activityDateTime).replaceAll("-", "")}_${changeSpecChars(activity.description)}";
  }

  static Future<void> createCreditCsv(List<TransactionItemModel> items, DateTime date, String description, List<UserModel> users) async {
    var headers = ["UserId", "Age", "Name", "LastName", "ClubId", "ClubName", "Amount", "ClubTransactionDate", "Description"];

    List<List<dynamic>> list = [];
    list.add(headers);

    for (var transaction in items) {
      var user = users.firstWhere((e) => e.id == transaction.userId);
      list.add([
        user.myShareID,
        (DateTime.now().difference(user.birthDate ?? DateTime.now()).inDays / 365).ceil() - 1,
        user.firstname,
        user.lastname,
        3964,
        "BUK Vácduka",
        transaction.credit,
        '${date.day}/${date.month}/${date.year}',
        description
      ]);
    }
    String csv = const ListToCsvConverter().convert(list);
    Uint8List bytes = Uint8List.fromList(utf8.encode(csv));

    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        name: '${dateToString(date).replaceAll("-", "")}_${changeSpecChars(description)}',
        bytes: bytes,
        ext: 'csv',
        mimeType: MimeType.csv,
      );
    } else {
      await FileSaver.instance.saveAs(
        name: '${dateToString(date).replaceAll("-", "")}_${changeSpecChars(description)}',
        bytes: bytes,
        ext: 'csv',
        mimeType: MimeType.csv,
      );
    }
  }

  static String getMonthFromDate(DateTime date, BuildContext context) {
    var locale = Localizations.localeOf(context);
    var format = DateFormat("MMMM", locale.countryCode);
    String formatted = format.format(date);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  static showErrorDialog(BuildContext context, {String? title, required String content}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(title: title, content: content),
    );
  }
}
