import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/style/app_colors.dart';

class ErrorAlertDialog extends StatelessWidget {
  const ErrorAlertDialog({super.key, required this.title, this.content});

  final String title;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AlertDialog(
            // backgroundColor: AppColors.white,
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    side: WidgetStateBorderSide.resolveWith(
                      (states) => BorderSide(color: AppColors.errorRed, width: 2.sp),
                    ),
                    backgroundColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                    foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
                    overlayColor: WidgetStateColor.resolveWith((states) => AppColors.errorRed),
                  ),
                  onPressed: () => context.pop(),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold),
                  ))
            ],
            content: content));
  }
}
