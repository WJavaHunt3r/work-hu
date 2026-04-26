import 'package:flutter/material.dart';

class ErrorSnackBar extends SnackBar {
  final String text;

  ErrorSnackBar({super.key, required this.text, required BuildContext context})
      : super(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          margin: const EdgeInsets.all(16),
          backgroundColor: Theme.of(context).colorScheme.error,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
}
