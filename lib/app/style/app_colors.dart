import 'package:flutter/material.dart';

/// Default colors depending on environment
class AppColors {
  //static const String envId = AppConfig.envId;
  static const Color primary = Color(0xFF173935);
  static const Color primary100 = Color(0xFF176635);
  static const Color primary200 = Color(0xFF181d18);

  static const Color gray100 = Color(0x44173935);

  static const Color errorRed = Color(0xFFC5032B);

  static const Color surfaceWhite = Color(0xFAf8f9fc);
  static const Color white = Colors.white;
  static const Color backgroundColor = Color(0xFFE3E7E9);
  static const Color backgroundColor100 = Color(0xFFE1E7E9);

  static const Color teamBlue = Color(0xFF636BFF);
  static const Color teamRed = Color(0xFFFF404D);
  static const Color teamGreen = Color(0xFF00DB8F);
  static const Color teamOrange = Color(0xFFFF6E00);
  static const Color appGreen = Color(0xFF173935);

  static const Color primaryGreen = Color(0xFF80b300);

  static const redRowBgColor = Color(0xAAFF9999);
  static const greenRowBgColor = Color(0xAA99FF99);
  static const yellowRowBgColor = Color(0xAAFFFF72);

  static final List<Color> listColors = [
    Colors.grey.shade100,
    Colors.grey.shade200,
    Colors.grey.shade300,
  ];

  static final List<Color> customerListColors = [
    Colors.blue.shade100,
    Colors.blue.shade200,
    Colors.blue.shade300,
  ];

  static var secondaryGray = Colors.grey.shade900;
}