import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';

class GlobalTheme {
  final globalTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _customColorScheme,
    primaryColor: AppColors.backgroundColor,
    fontFamily: "Poppins",
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 15.sp,
        color: AppColors.appGreen,
      ),
      bodyMedium: TextStyle(
        color: AppColors.appGreen,
        fontSize: 12.sp,
      ),
      bodySmall: TextStyle(
        fontSize: 10.sp,
        color: AppColors.appGreen,
      ),
      displayLarge: TextStyle(
        color: AppColors.appGreen,
        fontSize: 15.sp,
        fontFamily: 'Poppins',
      ),
      displayMedium: TextStyle(
        color: AppColors.appGreen,
        fontSize: 12.sp,
        fontFamily: 'Poppins',
      ),
      displaySmall: TextStyle(
        color: AppColors.appGreen,
        fontSize: 10.sp,
        fontFamily: 'Poppins',
      ),
      labelMedium: TextStyle(fontSize: 12.sp),
      labelLarge: TextStyle(fontSize: 15.sp),
      labelSmall: TextStyle(fontSize: 10.sp),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(10.sp),
        labelStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w100),
        fillColor: AppColors.white,
        filled: true,
        border: OutlineInputBorder(gapPadding: 8.sp, borderRadius: BorderRadius.all(Radius.circular(8.sp)))),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(fontSize: 18.sp, color: AppColors.primary),
      // This will control the "back" icon
      iconTheme: IconThemeData(color: AppColors.primary, size: 20.sp),
      elevation: 5.sp,
      // This will control action icon buttons that locates on the right
      actionsIconTheme: IconThemeData(size: 25.sp, color: AppColors.primary)
    ),
    cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
        margin: EdgeInsets.only(top: 8.sp),
        elevation: 5.sp,
        surfaceTintColor: AppColors.white,
        color: AppColors.white),
    // chipTheme: ChipThemeData(
    //     selectedColor: AppColors.primary,
    //     backgroundColor: AppColors.white,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
    //     labelStyle: TextStyle(fontSize: 14.sp, color: Colors.black)),
    // dialogTheme: DialogTheme(
    //   titleTextStyle: TextStyle(fontSize: 20.sp, color: Colors.black),
    //   contentTextStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
    //   alignment: Alignment.center,
    //   elevation: 8.sp,
    //   backgroundColor: AppColors.white,
    //   surfaceTintColor: AppColors.white,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.sp))),
    // ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.white,
      modalBackgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.sp), topRight: Radius.circular(25.sp)),
      ),
    ),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //     shape: const CircleBorder(), extendedPadding: EdgeInsets.all(8.sp), foregroundColor: AppColors.white),
    iconTheme: const IconThemeData(color: AppColors.primary),
    // buttonTheme: ButtonThemeData(
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)), padding: EdgeInsets.all(12.sp)),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            padding: EdgeInsets.all(10.sp),
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
    // disabledColor: Colors.white
  );

  static const ColorScheme _customColorScheme = ColorScheme(
      primary: AppColors.primary,
      secondary: AppColors.white,
      surface: AppColors.white,
      background: AppColors.backgroundColor,
      error: AppColors.errorRed,
      onPrimary: Colors.white,
      onSecondary: AppColors.primary,
      onSurface: AppColors.primary,
      onBackground: AppColors.primary,
      onError: Colors.redAccent,
      brightness: Brightness.light,
      outline: Colors.transparent);
}
