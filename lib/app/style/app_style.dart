import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';

class GlobalTheme {
  final globalTheme = ThemeData(
      useMaterial3: true,
      colorScheme: _customColorScheme,
      primaryColor: AppColors.backgroundColor,
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
        ),
        displayMedium: TextStyle(
          color: AppColors.appGreen,
          fontSize: 12.sp,
        ),
        displaySmall: TextStyle(
          color: AppColors.appGreen,
          fontSize: 10.sp,
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
          iconTheme: IconThemeData(color: AppColors.primary, size: 18.sp),
          // elevation: 5.sp,
          // scrolledUnderElevation: 10.sp,
          // surfaceTintColor: AppColors.white,
          // foregroundColor: AppColors.backgroundColor,
          backgroundColor: AppColors.backgroundColor,
          actionsIconTheme: IconThemeData(size: 18.sp, color: AppColors.primary)),
      cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
          margin: EdgeInsets.only(top: 8.sp),
          elevation: 0.sp,
          surfaceTintColor: AppColors.white,
          color: AppColors.white),
      chipTheme: ChipThemeData(
          selectedColor: AppColors.primary,
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: AppColors.primary),
          labelStyle: TextStyle(fontSize: 12.sp, color: Colors.black)),
      expansionTileTheme: ExpansionTileThemeData(tilePadding: EdgeInsets.only()),
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
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(foregroundColor: AppColors.white, backgroundColor: AppColors.primary),
      iconTheme: const IconThemeData(color: AppColors.primary),
      // buttonTheme: ButtonThemeData(
      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)), padding: EdgeInsets.all(12.sp)),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              padding: EdgeInsets.all(10.sp),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white, labelStyle: TextStyle(fontSize: 15.sp)))
      // disabledColor: Colors.white
      );

  static final ColorScheme _customColorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.white,
      surface: AppColors.backgroundColor,
      // background: AppColors.backgroundColor,
      error: AppColors.errorRed,
      onPrimary: Colors.white,
      onSecondary: AppColors.primary,
      onSurface: AppColors.primary,
      // onBackground: AppColors.primary,
      onError: Colors.redAccent,
      brightness: Brightness.light,
      outline: Colors.transparent);
}
