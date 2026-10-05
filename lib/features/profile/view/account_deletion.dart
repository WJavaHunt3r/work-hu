import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/locator.dart';

/// Asks for confirmation and sends the request to delete the signed-in user's account and all their data. An admin
/// receives it by e-mail and deletes the account by hand, so nothing is removed here.
Future<void> requestAccountDeletion(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text("delete_account_title".i18n()),
      content: Text("delete_account_question".i18n()),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text("base_cancel".i18n())),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Theme.of(dialogContext).colorScheme.error),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text("delete_account_confirm".i18n()),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  try {
    await locator<DioClient>().dio.post("/user/me/deletion-request");
    if (context.mounted) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text("delete_account_sent_title".i18n()),
          content: Text("delete_account_sent".i18n()),
          actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text("base_ok".i18n()))],
        ),
      );
    }
  } catch (e) {
    showApiError("delete_account_failed".i18n());
  }
}
