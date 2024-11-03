import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';

class GlobalTheme {
  final globalTheme = ThemeData(
      useMaterial3: true,
      colorScheme: _customColorScheme,
      brightness: Brightness.light,
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
          scrolledUnderElevation: 0.sp,
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: AppColors.backgroundColor),
          color: AppColors.backgroundColor,
          // foregroundColor: AppColors.backgroundColor,
          // backgroundColor: AppColors.backgroundColor,
          actionsIconTheme: IconThemeData(size: 18.sp, color: AppColors.primary)),
      cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
          margin: EdgeInsets.only(top: 8.sp),
          elevation: 0.sp,
          surfaceTintColor: AppColors.white,
          color: AppColors.white),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.white,
        backgroundColor: Colors.transparent,
        checkmarkColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
        secondaryLabelStyle: TextStyle(fontSize: 12.sp, color: AppColors.white),
        labelStyle: TextStyle(fontSize: 12.sp, color: AppColors.white),
        side: const BorderSide(color: AppColors.primary),
      ),
      expansionTileTheme: const ExpansionTileThemeData(tilePadding: EdgeInsets.only(), backgroundColor: Colors.white),
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
          style: ButtonStyle(
              padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(10.sp)),
              backgroundColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey.shade300;
                }
                return AppColors.primary;
              }),
              side: WidgetStateBorderSide.resolveWith(
                (states) {
                  if (states.contains(WidgetState.disabled)) {
                    return BorderSide(color: Colors.grey.shade300, width: 2.sp);
                  }
                  return BorderSide(color: AppColors.primary, width: 2.sp);
                },
              ),
              shape: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp));
                }
                return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp));
              }))),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white, labelStyle: TextStyle(fontSize: 15.sp))),
      bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyle(
            color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16.sp, overflow: TextOverflow.ellipsis),
        unselectedLabelStyle: TextStyle(
            color: AppColors.primary, fontWeight: FontWeight.normal, fontSize: 12.sp, overflow: TextOverflow.ellipsis),
        indicator: ShapeDecoration(
          color: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.sp)),
        ),
      ),
      dialogTheme: DialogTheme(
        data: DialogThemeData(
            backgroundColor: AppColors.backgroundColor,
            titleTextStyle: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
            )),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStateProperty.resolveWith((states) => 0),
        shadowColor: WidgetStateColor.resolveWith((states) => Colors.white),
        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.white),
        shape: WidgetStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.sp)),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
          hourMinuteTextStyle: TextStyle(fontSize: 30.sp),
          hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
          timeSelectorSeparatorTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(fontSize: 30.sp);
          }),
          cancelButtonStyle: ButtonStyle(
              padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4.sp)),
              foregroundColor: WidgetStateColor.resolveWith((states) {
                return AppColors.primary;
              }),
              backgroundColor: WidgetStateColor.resolveWith((states) {
                return Colors.transparent;
              }),
              side: WidgetStateProperty.resolveWith((states) {
                return const BorderSide(color: Colors.transparent, width: 0);
              })),
          confirmButtonStyle: ButtonStyle(
              padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4.sp)),
              foregroundColor: WidgetStateColor.resolveWith((states) {
                return AppColors.primary;
              }),
              backgroundColor: WidgetStateColor.resolveWith((states) {
                return Colors.transparent;
              }),
              side: WidgetStateProperty.resolveWith((states) {
                return const BorderSide(color: Colors.transparent, width: 0);
              }))),
      datePickerTheme: DatePickerThemeData(
          cancelButtonStyle: ButtonStyle(
              padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4.sp)),
              backgroundColor: WidgetStateColor.resolveWith((states) {
                return Colors.transparent;
              }),
              shape: WidgetStateProperty.resolveWith((states) {
                return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp));
              }),
              side: WidgetStateProperty.resolveWith((states) {
                return const BorderSide(color: Colors.transparent, width: 0);
              })),
          confirmButtonStyle: ButtonStyle(
              padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4.sp)),
              foregroundColor: WidgetStateColor.resolveWith((states) {
                return AppColors.primary;
              }),
              backgroundColor: WidgetStateColor.resolveWith((states) {
                return Colors.transparent;
              }),
              side: WidgetStateProperty.resolveWith((states) {
                return const BorderSide(color: Colors.transparent, width: 0);
              }),
              shape: WidgetStateProperty.resolveWith((states) {
                return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp));
              }))),
      listTileTheme: const ListTileThemeData(tileColor: Colors.white));

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

  final globalDarkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: _customDarkColorScheme,
      brightness: Brightness.dark,
      // primaryColor: Colors.black,
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 15.sp,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
        ),
        bodySmall: TextStyle(
          fontSize: 10.sp,
          color: Colors.white,
        ),
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
        ),
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
        ),
        labelMedium: TextStyle(fontSize: 12.sp),
        labelLarge: TextStyle(fontSize: 15.sp),
        labelSmall: TextStyle(fontSize: 10.sp),
      ),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(10.sp),
          labelStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w100, color: Colors.white),
          fillColor: Colors.black,
          filled: true,
          focusColor: Colors.white,
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(8.sp))),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              gapPadding: 8.sp,
              borderRadius: BorderRadius.all(Radius.circular(8.sp))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondaryGray),
              gapPadding: 8.sp,
              borderRadius: BorderRadius.all(Radius.circular(8.sp)))),
      appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 18.sp, color: Colors.white),
          iconTheme: IconThemeData(color: AppColors.white, size: 18.sp),
          // surfaceTintColor: null,
          color: Colors.black,
          // elevation: 0.sp,
          scrolledUnderElevation: 0.sp,
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.black),
          actionsIconTheme: IconThemeData(size: 18.sp, color: AppColors.backgroundColor)),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
        margin: EdgeInsets.only(top: 8.sp),
        elevation: 0.sp,
        // surfaceTintColor: AppColors.secondaryGray,
        color: AppColors.secondaryGray,
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStateProperty.resolveWith((states) => 0),
        shape: WidgetStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.sp)),
        ),
      ),
      chipTheme: ChipThemeData(
          selectedColor: AppColors.primary100,
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: AppColors.primary100),
          iconTheme: const IconThemeData(color: Colors.white),
          secondaryLabelStyle: TextStyle(fontSize: 12.sp, color: AppColors.primary100),
          labelStyle: TextStyle(fontSize: 12.sp, color: AppColors.backgroundColor)),
      expansionTileTheme: ExpansionTileThemeData(
          tilePadding: const EdgeInsets.only(),
          backgroundColor: AppColors.secondaryGray,
          collapsedBackgroundColor: AppColors.secondaryGray),
      navigationBarTheme: NavigationBarThemeData(
          surfaceTintColor: Colors.white,
          iconTheme: WidgetStateProperty.resolveWith((state) => const IconThemeData(color: AppColors.white))),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(foregroundColor: AppColors.white, backgroundColor: AppColors.primary100),
      iconTheme: const IconThemeData(color: AppColors.white),
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyle(
            color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16.sp, overflow: TextOverflow.ellipsis),
        unselectedLabelStyle: TextStyle(
            // color: AppColors.primary100,
            fontWeight: FontWeight.normal,
            fontSize: 12.sp,
            overflow: TextOverflow.ellipsis),
        indicator: ShapeDecoration(
          color: AppColors.primary100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.sp)),
        ),
      ),
      dialogTheme: DialogTheme(
        data: DialogThemeData(
            // backgroundColor: AppColors.secondaryGray,
            titleTextStyle: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w800,
          fontSize: 18.sp,
        )),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(10.sp)),
              backgroundColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey.shade600;
                }
                return AppColors.primary100;
              }),
              side: WidgetStateBorderSide.resolveWith(
                (states) {
                  if (states.contains(WidgetState.disabled)) {
                    return BorderSide(color: Colors.grey.shade600, width: 2.sp);
                  }
                  return BorderSide(color: AppColors.primary100, width: 2.sp);
                },
              ),
              shape: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp));
                }
                return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp));
              }))),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.white),
      dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(backgroundColor: WidgetStateColor.resolveWith((state) => AppColors.secondaryGray)),
          inputDecorationTheme: InputDecorationTheme(fillColor: Colors.black, labelStyle: TextStyle(fontSize: 15.sp))),
      // bottomAppBarTheme: BottomAppBarTheme(color: AppColors.secondaryGray),
      popupMenuTheme: PopupMenuThemeData(color: AppColors.secondaryGray, surfaceTintColor: AppColors.secondaryGray),
      timePickerTheme: TimePickerThemeData(
          hourMinuteTextStyle: TextStyle(fontSize: 30.sp),
          hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
          timeSelectorSeparatorTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(fontSize: 30.sp);
          }),
          cancelButtonStyle: ButtonStyle(
              padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4.sp)),
              foregroundColor: WidgetStateColor.resolveWith((states) {
                return AppColors.primary100;
              }),
              backgroundColor: WidgetStateColor.resolveWith((states) {
                return Colors.transparent;
              }),
              side: WidgetStateProperty.resolveWith((states) {
                return const BorderSide(color: Colors.transparent, width: 0);
              })),
          confirmButtonStyle: ButtonStyle(
            padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4.sp)),
            side: WidgetStateProperty.resolveWith((states) {
              return const BorderSide(color: Colors.transparent, width: 0);
            }),
            foregroundColor: WidgetStateColor.resolveWith((states) {
              return AppColors.primary100;
            }),
            backgroundColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.secondaryGray;
              }
              return Colors.transparent;
            }),
          )),
      datePickerTheme: DatePickerThemeData(
          cancelButtonStyle: ButtonStyle(
              padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4.sp)),
              backgroundColor: WidgetStateColor.resolveWith((states) {
                return Colors.transparent;
              }),
              shape: WidgetStateProperty.resolveWith((states) {
                return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp));
              }),
              side: WidgetStateProperty.resolveWith((states) {
                return const BorderSide(color: Colors.transparent, width: 0);
              })),
          confirmButtonStyle: ButtonStyle(
              padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4.sp)),
              foregroundColor: WidgetStateColor.resolveWith((states) {
                return AppColors.primary100;
              }),
              backgroundColor: WidgetStateColor.resolveWith((states) {
                return Colors.transparent;
              }),
              side: WidgetStateProperty.resolveWith((states) {
                return const BorderSide(color: Colors.transparent, width: 0);
              }),
              shape: WidgetStateProperty.resolveWith((states) {
                return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp));
              }))),
      listTileTheme: ListTileThemeData(tileColor: AppColors.secondaryGray));

  static final ColorScheme _customDarkColorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary100,
      primary: AppColors.primary100,
      secondary: AppColors.secondaryGray,
      surface: Colors.black,
      error: AppColors.errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      // onError: Colors.redAccent,
      brightness: Brightness.dark,
      outline: Colors.transparent);
}
