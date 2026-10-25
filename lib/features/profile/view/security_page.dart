import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/change_password/provider/change_password_provider.dart';
import 'package:work_hu/features/profile/data/state/profile_state.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/utils.dart';

/// `/profile/security`: the user changes their password (`POST /user/me/password`, the current one is required). That
/// signs out every other device; this one keeps its refresh token and stores the new access token from the answer.
/// Who signs in with Google or Apple doesn't know theirs (it is random), so they can have a reset link e-mailed.
class SecurityPage extends BasePage {
  const SecurityPage({super.key, super.title = "profile_password_security", super.canRefresh = false});

  /// Same rule as the backend's `UserPasswordService.MIN_LENGTH`.
  static const minPasswordLength = 8;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SecurityPageState();
}

class SecurityPageState extends BasePageState<SecurityPage, ProfileState, ProfileDataNotifier> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _again = TextEditingController();
  final _newNode = FocusNode();
  final _againNode = FocusNode();
  bool _saving = false;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _again.dispose();
    _newNode.dispose();
    _againNode.dispose();
    super.dispose();
  }

  Future<void> _change() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final refreshToken = await Utils.getData('refresh_token');
      final accessToken = await guardApi(
        () => ref.read(changePasswordRepoProvider).changeOwnPassword(_current.text, _new.text, refreshToken),
      );
      // The old access token stopped working with the change
      await Utils.saveData('jwt_token', accessToken);
      locator<UserProvider>().setToken(accessToken);
      _current.clear();
      _new.clear();
      _again.clear();
      FocusManager.instance.primaryFocus?.unfocus();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("security_password_changed_others_out".i18n())));
    } on ApiException catch (e) {
      // The backend answers 400 for a wrong current password (the length is checked here already)
      showApiError(e.statusCode == 400 ? "security_current_password_wrong".i18n() : e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _sendResetLink(String email) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AdaptiveAlertDialog(
        title: Text("security_send_reset_link".i18n()),
        content: Text("security_send_reset_link_question".i18n([email])),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text("security_send".i18n())),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await guardApi(() => ref.read(changePasswordRepoProvider).requestReset(email));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("security_reset_link_sent".i18n())));
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    }
  }

  @override
  Widget buildLayout() {
    final theme = Theme.of(context);
    final email = ref.watch(userDataProvider).user?.email;
    final inset = EdgeInsets.symmetric(horizontal: 18.sp);

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: inset.copyWith(bottom: 8.sp),
              child: Text(
                "change_password_viewname".i18n(),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Padding(
              padding: inset.copyWith(bottom: 8.sp),
              child: Text(
                "security_change_hint".i18n(),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
            ),
            BaseContainer(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: [
                  BaseTextFormField(
                    controller: _current,
                    labelText: "security_current_password".i18n(),
                    obscureText: true,
                    isPasswordField: true,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _newNode.requestFocus(),
                    fldControl: "3",
                  ),
                  BaseTextFormField(
                    controller: _new,
                    focusNode: _newNode,
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
                    onFieldSubmitted: (_) => _change(),
                    fldControl: "3",
                    validator: (text) => text != _new.text ? "login_password_not_match".i18n() : null,
                  ),
                  SizedBox(height: 8.sp),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saving ? null : _change,
                      child: Text("change_password_change_action".i18n()),
                    ),
                  ),
                ],
              ),
            ),
            if (email != null && email.isNotEmpty) ...[
              SizedBox(height: 16.sp),
              Padding(
                padding: inset,
                child: Text(
                  "security_forgot_hint".i18n(),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.sp),
                child: TextButton(
                  onPressed: () => _sendResetLink(email),
                  child: Text("security_send_reset_link".i18n()),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  StateNotifierProvider<ProfileDataNotifier, ProfileState> get provider => profileDataProvider;

  @override
  BaseState get status => state.status;
}
