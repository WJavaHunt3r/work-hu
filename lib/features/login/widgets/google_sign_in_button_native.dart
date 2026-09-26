import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

/// iOS / Android: a regular button that triggers `GoogleSignIn.authenticate()`.
Widget buildGoogleSignInButton({
  required BuildContext context,
  required bool isLogin,
  required String? languageCode,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.g_mobiledata, size: 32),
      label: Text((isLogin ? 'login_google_sign_in' : 'login_google_sign_up').i18n()),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
  );
}
