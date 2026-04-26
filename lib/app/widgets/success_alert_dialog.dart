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
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: content ??
                TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      "OK",
                    ))));
  }
}
