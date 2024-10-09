import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/dukapp.dart';

class NotchAppBar extends ConsumerWidget {
  const NotchAppBar(this.selectedIndex, {super.key});

  final num selectedIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      height: 60.sp,
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5.sp,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                isSelected: selectedIndex == 0,
                selectedIcon: Icon(Icons.run_circle_rounded, size: 25.sp, color: AppColors.primary),
                icon: Icon(Icons.run_circle_outlined, size: 25.sp, color: AppColors.primary),
                tooltip: 'myshare_status_status'.i18n(),
                onPressed: () => ref.watch(routerProvider).go("/home"),
              ),
              Text('myshare_status_status'.i18n())
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                isSelected: selectedIndex == 1,
                selectedIcon: Icon(Icons.person_2_rounded, size: 25.sp, color: AppColors.primary),
                icon: Icon(
                  Icons.person_2_outlined,
                  size: 25.sp,
                  color: AppColors.primary,
                ),
                tooltip: 'profile_title'.i18n(),
                onPressed: () => ref.watch(routerProvider).go("/profile"),
              ),
              Text('profile_title'.i18n())
            ],
          )
        ],
      ),
    );
  }
}
