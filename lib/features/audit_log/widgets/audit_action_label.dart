import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

/// Translated name of an audit action, or the raw name for actions this app version has no text for.
String auditActionLabel(String action) {
  final key = "audit_action_$action";
  final text = key.i18n();
  return text == key ? action : text;
}

/// Small coloured label for an audit action: creations green, deletions and refusals red, changes in the theme color.
class AuditActionLabel extends StatelessWidget {
  const AuditActionLabel(this.action, {super.key});

  final String action;

  Color _color(ColorScheme scheme) => switch (action) {
    "CREATE" || "REGISTER" => Colors.green,
    "UPDATE" || "ROLES_CHANGE" || "ROLE_PERMISSIONS_CHANGE" => scheme.primary,
    "DELETE" || "LOGIN_FAILED" || "ACCESS_DENIED" => scheme.error,
    "PASSWORD_CHANGE" || "PASSWORD_RESET" || "PASSWORD_SEND" => Colors.orange,
    _ => scheme.onSurfaceVariant,
  };

  @override
  Widget build(BuildContext context) {
    final color = _color(Theme.of(context).colorScheme);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 2.sp),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: color),
      ),
      child: Text(
        auditActionLabel(action),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
