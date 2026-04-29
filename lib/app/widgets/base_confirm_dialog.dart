import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/widgets/base_alert_dialog.dart';

class BaseConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() onConfirm;

  const BaseConfirmDialog({super.key, required this.title, required this.content, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return BaseAlertDialog(
      title: title.i18n(),
      content: Text(content.i18n(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
      onTap: () => onConfirm(),
    );
  }
}
