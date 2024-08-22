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
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            content: content ??
                TextButton(
                    style: ButtonStyle(
                      side: WidgetStateBorderSide.resolveWith(
                        (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                      ),
                      backgroundColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                      foregroundColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.focused) ||
                            states.contains(WidgetState.pressed) ||
                            states.contains(WidgetState.hovered)) {
                          return AppColors.white;
                        }
                        return AppColors.primary;
                      }),
                      overlayColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
                    ),
                    onPressed: () => context.pop(),
                    child: const Text(
                      "OK",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))));
  }
}
