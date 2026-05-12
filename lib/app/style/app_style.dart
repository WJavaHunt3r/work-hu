import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';

class GlobalTheme {
  final globalTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface:  const Color(0xFFfbf9f2),
          error:  const Color(0xFFCC533B),
          tertiary:  const Color(0xFF774f72),
          tertiaryContainer:  const Color(0xFFFDE4F7),
          secondary:  const Color(0xFF737A61),
          onTertiary: Colors.white,
          onPrimary: Colors.white,
          surfaceContainer:  const Color(0xFFefeee6),
          surfaceContainerHighest: Colors.white),
      fontFamily: 'Inter',
      // textTheme: TextTheme(
      //   bodyLarge: TextStyle(
      //     fontSize: 15,
      //     color: AppColors.appGreen,
      //   ),
      //   bodyMedium: TextStyle(
      //     color: AppColors.appGreen,
      //     fontSize: 12.sp,
      //   ),
      //   bodySmall: TextStyle(
      //     fontSize: 10,
      //     color: AppColors.appGreen,
      //   ),
      //   displayLarge: TextStyle(
      //     color: AppColors.appGreen,
      //     fontSize: 15,
      //   ),
      //   displayMedium: TextStyle(
      //     color: AppColors.appGreen,
      //     fontSize: 12.sp,
      //   ),
      //   displaySmall: TextStyle(
      //     color: AppColors.appGreen,
      //     fontSize: 10,
      //   ),
      //   labelMedium: TextStyle(fontSize: 12.sp),
      //   labelLarge: TextStyle(fontSize: 15),
      //   labelSmall: TextStyle(fontSize: 10),
      // ),
      // inputDecorationTheme: InputDecorationTheme(
      //     contentPadding: EdgeInsets.all(10),
      //     labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
      //     fillColor: AppColors.white,
      //     filled: true,
      //     border: OutlineInputBorder(gapPadding: 8, borderRadius: BorderRadius.all(Radius.circular(8)))),
      appBarTheme:  AppBarTheme(
          // titleTextStyle: TextStyle(fontSize: 18, color: AppColors.primary),
          // iconTheme: IconThemeData(color: AppColors.primary, size: 18),
          scrolledUnderElevation: 2.sp,
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: AppColors.backgroundColor),
          backgroundColor: AppColors.white,
          shadowColor: AppColors.surfaceWhite,
          actionsIconTheme: IconThemeData(size: 18.sp, color: AppColors.primary)),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
              padding:  EdgeInsets.symmetric(vertical: 16.sp, horizontal: 12.sp))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              backgroundColor:  const Color(0xFFefeee6),
              side: BorderSide.none,
              padding:  EdgeInsets.symmetric(vertical: 16.sp, horizontal: 12.sp),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)))),
      cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
          // margin: EdgeInsets.only(top: 24),
          elevation: 0,
          color: Colors.white),
      // chipTheme: ChipThemeData(
      //   selectedColor: AppColors.primary,
      //   secondarySelectedColor: AppColors.white,
      //   backgroundColor: Colors.transparent,
      //   checkmarkColor: Colors.white,
      //   iconTheme:  IconThemeData(color: AppColors.white),
      //   secondaryLabelStyle: TextStyle(fontSize: 12.sp, color: AppColors.white),
      //   labelStyle: TextStyle(fontSize: 12.sp, color: AppColors.white),
      //   side:  BorderSide(color: AppColors.primary),
      // ),
      // expansionTileTheme:  ExpansionTileThemeData(tilePadding: EdgeInsets.only(), backgroundColor: Colors.white),
      // dialogTheme: DialogTheme(
      //   titleTextStyle: TextStyle(fontSize: 20, color: Colors.black),
      //   contentTextStyle: TextStyle(fontSize: 14, color: Colors.black),
      //   alignment: Alignment.center,
      //   elevation: 8,
      //   backgroundColor: AppColors.white,
      //   surfaceTintColor: AppColors.white,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      // ),
      // bottomSheetTheme: BottomSheetThemeData(
      //   backgroundColor: AppColors.white,
      //   modalBackgroundColor: AppColors.white,
      //   surfaceTintColor: AppColors.white,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      //   ),
      // ),
      // floatingActionButtonTheme:
      //      FloatingActionButtonThemeData(foregroundColor: AppColors.white, backgroundColor: AppColors.primary),
      // iconTheme:  IconThemeData(color: AppColors.primary),
      // // buttonTheme: ButtonThemeData(
      // //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.all(12.sp)),
      // textButtonTheme: TextButtonThemeData(
      //     style: ButtonStyle(
      //         padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(10)),
      //         foregroundColor: WidgetStateColor.resolveWith((states) {
      //           if (states.contains(WidgetState.disabled)) {
      //             return Colors.grey;
      //           }
      //           return AppColors.white;
      //         }),
      //         backgroundColor: WidgetStateColor.resolveWith((states) {
      //           if (states.contains(WidgetState.disabled)) {
      //             return Colors.grey.shade300;
      //           }
      //           return AppColors.primary;
      //         }),
      //         side: WidgetStateBorderSide.resolveWith(
      //           (states) {
      //             if (states.contains(WidgetState.disabled)) {
      //               return BorderSide(color: Colors.grey.shade300, width: 2);
      //             }
      //             return BorderSide(color: AppColors.primary, width: 2);
      //           },
      //         ),
      //         shape: WidgetStateProperty.resolveWith((states) {
      //           return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
      //         }))),
      // progressIndicatorTheme:  ProgressIndicatorThemeData(color: AppColors.primary),
      // dropdownMenuTheme: DropdownMenuThemeData(
      //     inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white, labelStyle: TextStyle(fontSize: 15))),
      // // bottomAppBarTheme:  BottomAppBarThemeData(color: Colors.white),
      // tabBarTheme: TabBarThemeData(
      //   labelStyle:
      //       TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16.sp, overflow: TextOverflow.ellipsis),
      //   unselectedLabelStyle:
      //       TextStyle(color: AppColors.primary, fontWeight: FontWeight.normal, fontSize: 12.sp, overflow: TextOverflow.ellipsis),
      //   indicator: ShapeDecoration(
      //     color: AppColors.primary,
      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      //   ),
      // ),
      // dialogTheme: DialogThemeData(
      //     backgroundColor: AppColors.backgroundColor,
      //     titleTextStyle: TextStyle(
      //       color: AppColors.primary,
      //       fontWeight: FontWeight.w800,
      //       fontSize: 18,
      //     )),
      // searchBarTheme: SearchBarThemeData(
      //   elevation: WidgetStateProperty.resolveWith((states) => 0),
      //   shadowColor: WidgetStateColor.resolveWith((states) => Colors.white),
      //   backgroundColor: WidgetStateColor.resolveWith((states) => Colors.white),
      //   shape: WidgetStateProperty.resolveWith(
      //     (states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      //   ),
      // ),
      // timePickerTheme: TimePickerThemeData(
      //     hourMinuteTextStyle: TextStyle(fontSize: 30),
      //     hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //     timeSelectorSeparatorTextStyle: WidgetStateProperty.resolveWith((states) {
      //       return TextStyle(fontSize: 30);
      //     }),
      //     cancelButtonStyle: ButtonStyle(
      //         padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4)),
      //         foregroundColor: WidgetStateColor.resolveWith((states) {
      //           return AppColors.primary;
      //         }),
      //         backgroundColor: WidgetStateColor.resolveWith((states) {
      //           return Colors.transparent;
      //         }),
      //         side: WidgetStateProperty.resolveWith((states) {
      //           return  BorderSide(color: Colors.transparent, width: 0);
      //         })),
      //     confirmButtonStyle: ButtonStyle(
      //         padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4)),
      //         foregroundColor: WidgetStateColor.resolveWith((states) {
      //           return AppColors.primary;
      //         }),
      //         backgroundColor: WidgetStateColor.resolveWith((states) {
      //           return Colors.transparent;
      //         }),
      //         side: WidgetStateProperty.resolveWith((states) {
      //           return  BorderSide(color: Colors.transparent, width: 0);
      //         }))),
      // datePickerTheme: DatePickerThemeData(
      //     cancelButtonStyle: ButtonStyle(
      //         padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4)),
      //         backgroundColor: WidgetStateColor.resolveWith((states) {
      //           return Colors.transparent;
      //         }),
      //         shape: WidgetStateProperty.resolveWith((states) {
      //           return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
      //         }),
      //         side: WidgetStateProperty.resolveWith((states) {
      //           return  BorderSide(color: Colors.transparent, width: 0);
      //         })),
      //     confirmButtonStyle: ButtonStyle(
      //         padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4)),
      //         foregroundColor: WidgetStateColor.resolveWith((states) {
      //           return AppColors.primary;
      //         }),
      //         backgroundColor: WidgetStateColor.resolveWith((states) {
      //           return Colors.transparent;
      //         }),
      //         side: WidgetStateProperty.resolveWith((states) {
      //           return  BorderSide(color: Colors.transparent, width: 0);
      //         }),
      //         shape: WidgetStateProperty.resolveWith((states) {
      //           return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
      //         }))),
      listTileTheme:  ListTileThemeData(
          tileColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          selectedTileColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.sp)))));

  final globalDarkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        // primary: AppColors.primary,
        brightness: Brightness.dark,
        seedColor: AppColors.primary,
        // surface: Color(0xFFFfbf9f2),
        error:  const Color(0xFFBA1A1A),
        tertiary:  const Color(0xFF774f72),
        onTertiary: Colors.black,
        tertiaryContainer:  const Color(0xFF92678B),
        secondary:  const Color(0xFF5A614A),
        errorContainer:  const Color(0xFFFFDAD6),
        secondaryContainer:  const Color(0xFFDFE6C8),
        // secondary: Color(0xFFE8B634),
        surfaceContainer:  const Color(0xFF353535),
      ),
      // primaryColor: Colors.black,
      fontFamily: 'Roboto',
      // textTheme: TextTheme(
      //   bodyLarge: TextStyle(
      //     fontSize: 15,
      //     color: Colors.white,
      //   ),
      //   bodyMedium: TextStyle(
      //     color: Colors.white,
      //     fontSize: 12.sp,
      //   ),
      //   bodySmall: TextStyle(
      //     fontSize: 10,
      //     color: Colors.white,
      //   ),
      //   displayLarge: TextStyle(
      //     color: Colors.white,
      //     fontSize: 15,
      //   ),
      //   displayMedium: TextStyle(
      //     color: Colors.white,
      //     fontSize: 12.sp,
      //   ),
      //   displaySmall: TextStyle(
      //     color: Colors.white,
      //     fontSize: 10,
      //   ),
      //   labelMedium: TextStyle(fontSize: 12.sp),
      //   labelLarge: TextStyle(fontSize: 15),
      //   labelSmall: TextStyle(fontSize: 10),
      // ),
      // textSelectionTheme:  TextSelectionThemeData(cursorColor: Colors.white),
      // inputDecorationTheme: InputDecorationTheme(
      // contentPadding: EdgeInsets.all(10),
      // labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w100, color: Colors.white),
      // fillColor: Colors.black,
      // filled: true,
      // focusColor: Colors.white,
      // focusedBorder: OutlineInputBorder(
      //     borderSide:  BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(8))),
      // enabledBorder: OutlineInputBorder(
      //     borderSide:  BorderSide(color: Colors.grey),
      //     gapPadding: 8,
      //     borderRadius: BorderRadius.all(Radius.circular(8))),
      // border: OutlineInputBorder(
      //     borderSide: BorderSide(color: AppColors.secondaryGray),
      //     gapPadding: 8,
      //     borderRadius: BorderRadius.all(Radius.circular(8)))
      //     ),
      // appBarTheme: AppBarTheme(
      //     titleTextStyle: TextStyle(fontSize: 18, color: Colors.white),
      //     iconTheme: IconThemeData(color: AppColors.white, size: 18),
      //     // surfaceTintColor: null,
      //     color: Colors.black,
      //     // elevation: 0,
      //     scrolledUnderElevation: 0,
      //     systemOverlayStyle:  SystemUiOverlayStyle(statusBarColor: Colors.black),
      //     actionsIconTheme: IconThemeData(size: 18, color: AppColors.backgroundColor)),
      appBarTheme: AppBarTheme(
          // titleTextStyle: TextStyle(fontSize: 18, color: AppColors.primary),
          // iconTheme: IconThemeData(color: AppColors.primary, size: 18),
          scrolledUnderElevation: 2.sp,
          systemOverlayStyle:  const SystemUiOverlayStyle(statusBarColor: Colors.black),
          backgroundColor: AppColors.secondaryGray,
          shadowColor: AppColors.surfaceWhite,
          actionsIconTheme:  IconThemeData(size: 18.sp, color: AppColors.primary)),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
              padding:  EdgeInsets.symmetric(vertical: 16.sp, horizontal: 12.sp))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              backgroundColor:  const Color(0xFFefeee6),
              foregroundColor: AppColors.primary,
              side: BorderSide.none,
              padding:  EdgeInsets.symmetric(vertical: 16.sp, horizontal: 12.sp),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)))),
      cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.sp)),
          // margin: EdgeInsets.only(top: 24),
          color:  const Color(0xFF5A614A),
          elevation: 0),
      // searchBarTheme: SearchBarThemeData(
      //   elevation: WidgetStateProperty.resolveWith((states) => 0),
      //   shape: WidgetStateProperty.resolveWith(
      //     (states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      //   ),
      // ),
      // chipTheme: ChipThemeData(
      //     selectedColor: AppColors.primary100,
      //     backgroundColor: Colors.transparent,
      //     side:  BorderSide(color: AppColors.primary100),
      //     iconTheme:  IconThemeData(color: Colors.white),
      //     secondaryLabelStyle: TextStyle(fontSize: 12.sp, color: AppColors.primary100),
      //     labelStyle: TextStyle(fontSize: 12.sp, color: AppColors.backgroundColor)),
      // expansionTileTheme: ExpansionTileThemeData(
      //     tilePadding:  EdgeInsets.only(),
      //     backgroundColor: AppColors.secondaryGray,
      //     collapsedBackgroundColor: AppColors.secondaryGray),
      // // navigationBarTheme: NavigationBarThemeData(
      // //     surfaceTintColor: Colors.white,
      // //     iconTheme: WidgetStateProperty.resolveWith((state) =>  IconThemeData(color: AppColors.white))),
      // floatingActionButtonTheme:
      //      FloatingActionButtonThemeData(foregroundColor: AppColors.white, backgroundColor: AppColors.primary100),
      // iconTheme:  IconThemeData(color: AppColors.white),
      tabBarTheme: TabBarThemeData(
        labelStyle:
            TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16.sp, overflow: TextOverflow.ellipsis),
        unselectedLabelStyle: TextStyle(
            // color: AppColors.primary100,
            fontWeight: FontWeight.normal,
            fontSize: 12.sp,
            overflow: TextOverflow.ellipsis),
      ),
      // dialogTheme: DialogThemeData(
      //   // backgroundColor: AppColors.secondaryGray,
      //   titleTextStyle: TextStyle(
      //     color: AppColors.white,
      //     fontWeight: FontWeight.w800,
      //     fontSize: 18,
      //   ),
      // ),
      // textButtonTheme: TextButtonThemeData(
      //     style: ButtonStyle(
      //         padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(10)),
      //         foregroundColor: WidgetStateColor.resolveWith((states) {
      //           if (states.contains(WidgetState.disabled)) {
      //             return Colors.grey;
      //           }
      //           return AppColors.white;
      //         }),
      //         backgroundColor: WidgetStateColor.resolveWith((states) {
      //           if (states.contains(WidgetState.disabled)) {
      //             return Colors.grey.shade300;
      //           }
      //           return AppColors.primary;
      //         }),
      //         side: WidgetStateBorderSide.resolveWith(
      //           (states) {
      //             if (states.contains(WidgetState.disabled)) {
      //               return BorderSide(color: Colors.grey.shade300, width: 2);
      //             }
      //             return BorderSide(color: AppColors.primary, width: 2);
      //           },
      //         ),
      //         shape: WidgetStateProperty.resolveWith((states) {
      //           return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
      //         }))),
      // progressIndicatorTheme:  ProgressIndicatorThemeData(color: AppColors.white),
      // dropdownMenuTheme: DropdownMenuThemeData(
      //     menuStyle: MenuStyle(backgroundColor: WidgetStateColor.resolveWith((state) => AppColors.secondaryGray)),
      //     inputDecorationTheme: InputDecorationTheme(fillColor: Colors.black, labelStyle: TextStyle(fontSize: 15))),
      // // bottomAppBarTheme: BottomAppBarTheme(color: AppColors.secondaryGray),
      // popupMenuTheme: PopupMenuThemeData(color: AppColors.secondaryGray, surfaceTintColor: AppColors.secondaryGray),
      // timePickerTheme: TimePickerThemeData(
      //     hourMinuteTextStyle: TextStyle(fontSize: 30),
      //     hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //     timeSelectorSeparatorTextStyle: WidgetStateProperty.resolveWith((states) {
      //       return TextStyle(fontSize: 30);
      //     }),
      //     cancelButtonStyle: ButtonStyle(
      //         padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4)),
      //         foregroundColor: WidgetStateColor.resolveWith((states) {
      //           return AppColors.primary100;
      //         }),
      //         backgroundColor: WidgetStateColor.resolveWith((states) {
      //           return Colors.transparent;
      //         }),
      //         side: WidgetStateProperty.resolveWith((states) {
      //           return  BorderSide(color: Colors.transparent, width: 0);
      //         })),
      //     confirmButtonStyle: ButtonStyle(
      //       padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4)),
      //       side: WidgetStateProperty.resolveWith((states) {
      //         return  BorderSide(color: Colors.transparent, width: 0);
      //       }),
      //       foregroundColor: WidgetStateColor.resolveWith((states) {
      //         return AppColors.primary100;
      //       }),
      //       backgroundColor: WidgetStateColor.resolveWith((states) {
      //         if (states.contains(WidgetState.disabled)) {
      //           return AppColors.secondaryGray;
      //         }
      //         return Colors.transparent;
      //       }),
      //     )),
      // datePickerTheme: DatePickerThemeData(
      //     cancelButtonStyle: ButtonStyle(
      //         padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4)),
      //         backgroundColor: WidgetStateColor.resolveWith((states) {
      //           return Colors.transparent;
      //         }),
      //         shape: WidgetStateProperty.resolveWith((states) {
      //           return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
      //         }),
      //         side: WidgetStateProperty.resolveWith((states) {
      //           return  BorderSide(color: Colors.transparent, width: 0);
      //         })),
      //     confirmButtonStyle: ButtonStyle(
      //         padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.all(4)),
      //         foregroundColor: WidgetStateColor.resolveWith((states) {
      //           return AppColors.primary100;
      //         }),
      //         backgroundColor: WidgetStateColor.resolveWith((states) {
      //           return Colors.transparent;
      //         }),
      //         side: WidgetStateProperty.resolveWith((states) {
      //           return  BorderSide(color: Colors.transparent, width: 0);
      //         }),
      //         shape: WidgetStateProperty.resolveWith((states) {
      //           return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
      //         }))),
      listTileTheme:  ListTileThemeData(
          tileColor: Colors.transparent,
          contentPadding:  const EdgeInsets.all(0),
          selectedTileColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.sp)))));
}
