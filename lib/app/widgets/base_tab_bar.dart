import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';

class BaseTabView extends StatelessWidget {
  const BaseTabView({super.key, required this.tabs, required this.tabViews, this.padding});

  final List<Tab> tabs;
  final List<Widget> tabViews;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: padding ?? 0.sp),
              child: Container(
                  padding: EdgeInsets.all(0.5.sp),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5.sp,color: AppColors.primary,),
                      borderRadius: BorderRadius.all(Radius.circular(30.sp))),
                  child: TabBar(
                      dividerColor: Colors.transparent,
                      labelPadding: EdgeInsets.all(0.sp),
                      splashBorderRadius: BorderRadius.all(Radius.circular(30.sp)),
                      padding: EdgeInsets.all(0.sp),
                      tabs: tabs)),
            )),
        body: TabBarView(clipBehavior: Clip.antiAlias, children: tabViews));
  }
}
