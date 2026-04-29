import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';

class BaseAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final Function() onTap;
  final String? confirmText;
  final bool canPop;
  final bool confirmVisible;
  final bool cancelVisible;

  const BaseAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onTap,
    this.confirmText,
    this.canPop = true,
    this.confirmVisible = true,
    this.cancelVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title.i18n(), textAlign: TextAlign.center),
      content: content,
      constraints: BoxConstraints(minWidth: 600),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        if (cancelVisible)
          OutlinedButton(
            onPressed: () => context.pop(),
            child: Text("base_cancel".i18n(), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red)),
          ),
        if (confirmVisible)
          FilledButton(
            style: Theme.of(context).filledButtonTheme.style?.copyWith(backgroundColor: WidgetStatePropertyAll(Colors.green)),
            onPressed: () {
              onTap();
              if (canPop) context.pop(true);
            },
            child: Text(
              confirmText != null ? confirmText!.i18n() : "base_ok".i18n(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
      ],
    );
  }
}
