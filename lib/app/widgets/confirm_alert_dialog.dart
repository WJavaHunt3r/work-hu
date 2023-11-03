import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/style/app_colors.dart';

class ConfirmAlertDialog extends StatelessWidget {
  const ConfirmAlertDialog({super.key, required this.onConfirm, required this.title, required this.content, this.icon});

  final Function() onConfirm;
  final String title;
  final Widget content;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 18.sp,
        ),
        icon: icon,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        backgroundColor: AppColors.white,
        actions: [
          TextButton(
              style: ButtonStyle(
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                ),
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                foregroundColor: MaterialStateColor.resolveWith((states) => AppColors.white),
                overlayColor: MaterialStateColor.resolveWith((states) => AppColors.primary),
              ),
              onPressed: () => context.pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              )),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.primary),
                foregroundColor: MaterialStateColor.resolveWith((states) => AppColors.white),
              ),
              onPressed: onConfirm,
              child: const Text(
                "Confirm",
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
              ))
        ],
        content: content);
  }
}
