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
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';

class Utils {
  static const FlutterSecureStorage _storage =
      FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

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
      return long ? "base_text_points".i18n() : "base_text_points_short".i18n();
    } else if ([TransactionType.HOURS, TransactionType.DUKA_MUNKA, TransactionType.DUKA_MUNKA_2000]
        .contains(transactionType)) {
      return long ? "base_text_hours".i18n() : "base_text_hours_short".i18n();
    } else if (transactionType == TransactionType.CREDIT) {
      return long ? "base_text_credits".i18n() : "base_text_credits_short".i18n();
    }
    return "";
  }

  static final NumberFormat creditFormat = NumberFormat("#,###");
  static final NumberFormat percentFormat = NumberFormat.decimalPatternDigits(decimalDigits: 1);

  static String creditFormatting(num number) {
    return creditFormat.format(number).replaceAll(",", " ");
  }

  static String dateToString(DateTime date) {
    return "${date.year}-${date.month < 10 ? "0${date.month}" : date.month}-${date.day < 10 ? "0${date.day}" : date.day}";
  }

  static String dateToStringUnformatted(DateTime date) {
    return "${date.year}${date.month < 10 ? "0${date.month}" : date.month}${date.day < 10 ? "0${date.day}" : date.day}";
  }

  static String dateToStringWithTime(DateTime date) {
    return "${date.year}-${date.month < 10 ? "0${date.month}" : date.month}-${date.day < 10 ? "0${date.day}" : date.day} ${date.hour < 10 ? "0${date.hour}" : date.hour}:${date.minute < 10 ? "0${date.minute}" : date.minute}";
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
        ),
        freezeDateTime: DateTime.now(),
        activeRound: true);
  }

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

  static void createActivityXlsx(List<ActivityItemsModel> items, ActivityModel activity) async {
    var excel = await buildActivityXlsx(items, activity);
    if (kIsWeb) {
      excel.save(fileName: "${createFileName(activity)}.xlsx");
    } else {
      var newBytes = excel.save();
      if (newBytes != null) {
        await FileSaver.instance.saveAs(
          name: createFileName(activity),
          bytes: Uint8List.fromList(newBytes),
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );
      }
    }
  }

  static Future<Excel> buildActivityXlsx(List<ActivityItemsModel> items, ActivityModel activity) async {
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
    var sumCredits = activity.account == Account.MYSHARE && activity.transactionType == TransactionType.DUKA_MUNKA
        ? items.map((e) => (e.hours * 1000).toInt()).reduce((value, element) => value + element)
        : activity.account == Account.OTHER && activity.transactionType == TransactionType.POINT
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
      creditCell.value = activity.account == Account.MYSHARE && activity.transactionType == TransactionType.DUKA_MUNKA
          ? DoubleCellValue(item.hours * 1000)
          : activity.account == Account.MYSHARE && activity.transactionType == TransactionType.HOURS
              ? DoubleCellValue(item.hours * 2000)
              : TextCellValue("");
    }

    return excel;
  }

  static Future<void> createCreditCsv(List<TransactionItemModel> items, DateTime date, String description) async {
    var headers = [
      "UserId",
      "Age",
      "Name",
      "LastName",
      "ClubId",
      "ClubName",
      "Amount",
      "ClubTransactionDate",
      "Description"
    ];

    List<List<dynamic>> list = [];
    list.add(headers);

    for (var transaction in items) {
      var user = transaction.user;
      list.add([
        user.myShareID,
        (DateTime.now().difference(user.birthDate).inDays / 365).ceil() - 1,
        user.firstname,
        user.lastname,
        3964,
        "BUK Vácduka",
        transaction.credit,
        '${date.month}/${date.day}/${date.year}',
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
}
