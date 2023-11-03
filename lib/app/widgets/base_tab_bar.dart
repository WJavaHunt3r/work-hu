import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';

class BaseTabBar extends StatelessWidget {
  const BaseTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0.5.sp),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 1.5.sp),
            borderRadius: BorderRadius.all(Radius.circular(30.sp))),
        child: TabBar(
            unselectedLabelStyle: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.normal,
                fontSize: 14.sp,
                overflow: TextOverflow.ellipsis),
            labelStyle: TextStyle(
                color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18.sp, overflow: TextOverflow.ellipsis),
            dividerColor: Colors.transparent,
            labelPadding: EdgeInsets.all(0.sp),
            splashBorderRadius: BorderRadius.all(Radius.circular(30.sp)),
            padding: EdgeInsets.all(0.sp),
            indicator: ShapeDecoration(
              color: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.sp)),
            ),
            tabs: tabs));
  }
}
