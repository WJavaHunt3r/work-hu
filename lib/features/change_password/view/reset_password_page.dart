import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/change_password/provider/change_password_provider.dart';
import 'package:work_hu/features/profile/view/security_page.dart';

/// `/reset-password?token=...` (public): where the e-mailed one-time link leads. Asks the backend whether the link can
/// still be used, then sets the new password with it. That signs the account out on every device, this one included,
/// so it ends at the login page.
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key, required this.token});

  final String token;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

enum _LinkState { checking, valid, invalid }

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _new = TextEditingController();
  final _again = TextEditingController();
  final _againNode = FocusNode();
  _LinkState _link = _LinkState.checking;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  void dispose() {
    _new.dispose();
    _again.dispose();
    _againNode.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    if (widget.token.isEmpty) {
      setState(() => _link = _LinkState.invalid);
      return;
    }
    try {
      await ref.read(changePasswordRepoProvider).checkReset(widget.token);
      if (mounted) setState(() => _link = _LinkState.valid);
    } catch (_) {
      // 410 (used / expired) or no connection: either way the form can't be used now
      if (mounted) setState(() => _link = _LinkState.invalid);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await guardApi(() => ref.read(changePasswordRepoProvider).confirmReset(widget.token, _new.text));
      // Every session of the account ended with the change, also one on this device
      final userProvider = ref.read(userDataProvider);
      if (userProvider.user != null) await userProvider.logout();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("reset_password_done".i18n())));
      context.go('/login');
    } on ApiException catch (e) {
      if (e.statusCode == 410) {
        setState(() => _link = _LinkState.invalid);
      } else {
        showApiError(e.message);
      }
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("reset_password_title".i18n(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.sp),
        children: [
          switch (_link) {
            _LinkState.checking => Padding(
              padding: EdgeInsets.symmetric(vertical: 48.sp),
              child: const Center(child: CircularProgressIndicator.adaptive()),
            ),
            _LinkState.invalid => BaseContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.link_off, color: theme.colorScheme.error, size: 32.sp),
                  SizedBox(height: 12.sp),
                  Text("reset_password_invalid".i18n(), style: theme.textTheme.bodyLarge),
                  SizedBox(height: 16.sp),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.go('/login'),
                      child: Text("reset_password_to_login".i18n()),
                    ),
                  ),
                ],
              ),
            ),
            _LinkState.valid => Form(
              key: _formKey,
              child: AutofillGroup(
                child: BaseContainer(
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("reset_password_hint".i18n(), style: theme.textTheme.bodyMedium),
                      SizedBox(height: 8.sp),
                      BaseTextFormField(
                        controller: _new,
                        labelText: "change_password_new_password".i18n(),
                        obscureText: true,
                        isPasswordField: true,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _againNode.requestFocus(),
                        fldControl: "3",
                        validator: (text) => (text ?? "").length < SecurityPage.minPasswordLength
                            ? "security_password_too_short".i18n(["${SecurityPage.minPasswordLength}"])
                            : null,
                      ),
                      BaseTextFormField(
                        controller: _again,
                        focusNode: _againNode,
                        labelText: "change_password_new_password_again".i18n(),
                        obscureText: true,
                        isPasswordField: true,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _save(),
                        fldControl: "3",
                        validator: (text) => text != _new.text ? "login_password_not_match".i18n() : null,
                      ),
                      SizedBox(height: 8.sp),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _saving ? null : _save,
                          child: Text("reset_password_save".i18n()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          },
        ],
      ),
    );
  }
}
