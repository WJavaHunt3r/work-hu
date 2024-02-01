import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/style/app_colors.dart';

class SuccessAlertDialog extends StatelessWidget {
  const SuccessAlertDialog({super.key, required this.title, this.content});

  final String title;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
            ),
            content: content ??
                TextButton(
                    style: ButtonStyle(
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(color: AppColors.primaryGreen, width: 2.sp),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                      foregroundColor: MaterialStateColor.resolveWith((states) => AppColors.white),
                      overlayColor: MaterialStateColor.resolveWith((states) => AppColors.primaryGreen),
                    ),
                    onPressed: () => context.pop(),
                    child: const Text(
                      "OK",
                      style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                    ))));
  }
}
