import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
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
                side: WidgetStateBorderSide.resolveWith(
                  (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                ),
                backgroundColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
                overlayColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
              ),
              onPressed: () => context.pop(),
              child: Text(
                "cancel".i18n(),
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              )),
          TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
                foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
              ),
              onPressed: onConfirm,
              child: Text(
                "confirm".i18n(),
                style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
              ))
        ],
        content: content);
  }
}
