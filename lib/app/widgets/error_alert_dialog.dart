import 'package:flutter/material.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/platform/adaptive.dart';

class ErrorAlertDialog extends StatelessWidget {
  const ErrorAlertDialog({super.key, required this.title, this.content});

  final String title;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AdaptiveAlertDialog(
        // backgroundColor: AppColors.white,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        content: content,
      ),
    );
  }
}
