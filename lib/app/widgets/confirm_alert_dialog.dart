import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/platform/adaptive.dart';

class ConfirmAlertDialog extends StatelessWidget {
  const ConfirmAlertDialog({super.key, required this.onConfirm, required this.title, required this.content, this.icon});

  final Function() onConfirm;
  final String title;
  final Widget content;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return AdaptiveAlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      icon: icon,
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("cancel".i18n())),
        FilledButton(
          onPressed: onConfirm,
          child: Text("confirm".i18n(), style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
      ],
      content: content,
    );
  }
}
