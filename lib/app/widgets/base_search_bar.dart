import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/style/app_colors.dart';

class BaseSearchBar extends StatelessWidget {
  const BaseSearchBar({super.key, required this.onChanged});

  final Function(String text) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.sp),
      child: SearchBar(
        shadowColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
        surfaceTintColor: WidgetStateColor.resolveWith((states) => AppColors.white),
        shape: WidgetStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
        ),
        hintText: "goals_search".i18n(),
        onChanged: (text) => onChanged(text),
      ),
    );
  }
}
