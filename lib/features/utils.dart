import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import "package:pointycastle/export.dart";
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
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

  static void createActivityCsv(List<ActivityItemsModel> items, ActivityModel activity) async {
    ByteData data = await rootBundle.load('assets/docs/munkalap_sablon_uj.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    Sheet sheetObject = excel['Munka1'];
    var employerCell = sheetObject.cell(CellIndex.indexByString('C2'));
    employerCell.value = null;
    employerCell.value = TextCellValue(activity.employer.getFullName());
    employerCell.cellStyle =
        (employerCell.cellStyle ?? CellStyle()).copyWith(horizontalAlignVal: HorizontalAlign.Right);

    var descriptionCell = sheetObject.cell(CellIndex.indexByString('C3'));
    descriptionCell.value = null;
    descriptionCell.value = TextCellValue(activity.description);
    descriptionCell.cellStyle =
        (descriptionCell.cellStyle ?? CellStyle()).copyWith(horizontalAlignVal: HorizontalAlign.Right);

    var responsibleCell = sheetObject.cell(CellIndex.indexByString('C4'));
    responsibleCell.value = null;
    responsibleCell.value = TextCellValue(activity.responsible.getFullName());
    responsibleCell.cellStyle =
        (responsibleCell.cellStyle ?? CellStyle()).copyWith(horizontalAlignVal: HorizontalAlign.Right);

    var activityIdCell = sheetObject.cell(CellIndex.indexByString('F1'));
    activityIdCell.value = null;
    activityIdCell.value = IntCellValue(activity.activityId?.toInt() ?? 0);

    var activityDateCell = sheetObject.cell(CellIndex.indexByString('F2'));
    activityDateCell.value = null;
    var date = activity.activityDateTime;
    activityDateCell.value =
        DateTimeCellValue(year: date.year, month: date.month, day: date.day, hour: date.hour, minute: date.minute);

    var sumHoursCell = sheetObject.cell(CellIndex.indexByString('F3'));
    var sumHours = items.map((e) => e.hours).reduce((value, element) => value + element);
    sumHoursCell.value = null;
    sumHoursCell.value = DoubleCellValue(sumHours);

    var sumCreditsCell = sheetObject.cell(CellIndex.indexByString('F4'));
    var sumCredits = activity.account == Account.OTHER
        ? 0
        : items.map((e) => (e.hours * 2000).toInt()).reduce((value, element) => value + element);
    sumCreditsCell.value = null;
    sumCreditsCell.value = IntCellValue(sumCredits);

    for (var item in items) {
      var indexCell = sheetObject.cell(CellIndex.indexByString('A${5 + items.indexOf(item) + 1}'));
      indexCell.value = null;
      indexCell.value = IntCellValue(items.indexOf(item) + 1);

      var myShareCell = sheetObject.cell(CellIndex.indexByString('B${5 + items.indexOf(item) + 1}'));
      myShareCell.value = null;
      myShareCell.value = IntCellValue(item.user.myShareID.toInt());

      var nameCell = sheetObject.cell(CellIndex.indexByString('C${5 + items.indexOf(item) + 1}'));
      nameCell.value = null;
      nameCell.value = TextCellValue(item.user.getFullName());
      nameCell.cellStyle = (nameCell.cellStyle ?? CellStyle()).copyWith(horizontalAlignVal: HorizontalAlign.Right);

      var ageCell = sheetObject.cell(CellIndex.indexByString('D${5 + items.indexOf(item) + 1}'));
      ageCell.value = null;
      ageCell.value = IntCellValue(item.user.getAge().toInt());

      var hourCell = sheetObject.cell(CellIndex.indexByString('E${5 + items.indexOf(item) + 1}'));
      hourCell.value = null;
      hourCell.value = DoubleCellValue(item.hours);

      var creditCell = sheetObject.cell(CellIndex.indexByString('F${5 + items.indexOf(item) + 1}'));
      creditCell.value = null;
      creditCell.value =
          activity.account == Account.OTHER ? const TextCellValue("") : DoubleCellValue(item.hours * 2000);
    }

    if (kIsWeb) {
      excel.save(fileName: "${dateToString(date).replaceAll("-", "")}_${changeHunChars(activity.description)}.xlsx");
      // await FileSaver.instance.saveFile(
      //   name: "${dateToString(date).replaceAll("-", "")}_${changeHunChars(activity.description)}",
      //   bytes: bytes,
      //   ext: 'csv',
      //   mimeType: MimeType.csv,
      // );
    } else {
      var newBytes = excel.save();
      if (newBytes != null) {
        await FileSaver.instance.saveAs(
          name: "${dateToString(date).replaceAll("-", "")}_${changeHunChars(activity.description)}",
          bytes: Uint8List.fromList(newBytes),
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );
      }
    }
  }
}
