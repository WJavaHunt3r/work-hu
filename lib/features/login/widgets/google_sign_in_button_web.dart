import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// Web: renders the Google Identity Services button. Sign-in results arrive
/// through `GoogleSignIn.instance.authenticationEvents`, so [onPressed] is unused.
Widget buildGoogleSignInButton({
  required BuildContext context,
  required bool isLogin,
  required String? languageCode,
  required VoidCallback onPressed,
}) {
  return web.renderButton(
    configuration: web.GSIButtonConfiguration(
      type: web.GSIButtonType.standard,
      theme: web.GSIButtonTheme.outline,
      size: web.GSIButtonSize.large,
      text: isLogin ? web.GSIButtonText.signinWith : web.GSIButtonText.signupWith,
      shape: web.GSIButtonShape.rectangular,
      locale: languageCode,
    ),
  );
}
