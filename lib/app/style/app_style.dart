import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';

class GlobalTheme {
  final globalTheme = ThemeData(
      useMaterial3: true,
      colorScheme: _customColorScheme,
      fontFamily: "Poppins",
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 22.sp,
          color: AppColors.appGreen,
        ),
        bodyMedium: TextStyle(
          color: AppColors.appGreen,
          fontSize: 20.sp,
        ),
        bodySmall: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: AppColors.appGreen,
        ),
        displayLarge: TextStyle(
          color: AppColors.appGreen,
          fontSize: 10.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.appGreen,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: TextStyle(fontSize: 20.sp),
        labelLarge: TextStyle(fontSize: 20.sp),
      ),
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(fontSize: 17.sp),
          fillColor: AppColors.white,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide.none, gapPadding: 8.sp, borderRadius: BorderRadius.all(Radius.circular(12.sp)))),
      appBarTheme: AppBarTheme(
          // This will control the "back" icon
          iconTheme: IconThemeData(size: 25.sp, color: AppColors.white),
          // This will control action icon buttons that locates on the right
          actionsIconTheme: IconThemeData(size: 25.sp),
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25.sp, overflow: TextOverflow.ellipsis, color: Colors.black),
          color: AppColors.white),
      cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
          margin: EdgeInsets.only(left: 8.sp, right: 8.sp, top: 8.sp),
          elevation: 0.sp,
          color: AppColors.white),
      chipTheme: ChipThemeData(
          selectedColor: AppColors.primary,
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
          labelStyle: TextStyle(fontSize: 14.sp, color: Colors.black)),
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(fontSize: 20.sp, color: Colors.black),
        contentTextStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
        alignment: Alignment.center,
        elevation: 8.sp,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.sp))),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.white,
        modalBackgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.sp), topRight: Radius.circular(25.sp)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: const CircleBorder(), extendedPadding: EdgeInsets.all(8.sp), foregroundColor: AppColors.white),
      iconTheme: IconThemeData(size: 20.sp),
      buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)), padding: EdgeInsets.all(12.sp)),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              padding: EdgeInsets.all(8.sp),
              textStyle: TextStyle(fontSize: 18.sp, color: AppColors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      disabledColor: Colors.white);

  static const ColorScheme _customColorScheme = ColorScheme(
      primary: AppColors.primary,
      secondary: AppColors.white,
      surface: AppColors.backgroundColor,
      background: AppColors.white,
      error: AppColors.errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: AppColors.primary,
      onBackground: Colors.black,
      onError: Colors.redAccent,
      brightness: Brightness.light,
      outline: Colors.transparent);
}
