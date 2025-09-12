import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_hu/app/data/models/app_theme_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/success_alert_dialog.dart';
import 'package:work_hu/features/change_password/provider/change_password_provider.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';

class LoginLayout extends ConsumerWidget {
  LoginLayout({required this.origRoute, super.key});

  final String origRoute;
  static final _formKey = GlobalKey<FormState>();
  final FocusNode passwordNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginProvider = ref.watch(loginDataProvider.notifier);
    var isDark = ref.watch(themeProvider) == AppThemeMode.dark;
    return Stack(
      children: [
        Form(
            key: _formKey,
            child: AutofillGroup(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "DukApp",
                  style: TextStyle(fontFamily: "Good-Timing", fontWeight: FontWeight.bold, fontSize: 40.sp),
                ),
                Column(children: [
                  BaseTextFormField(
                    controller: loginProvider.usernameController,
                    textInputAction: TextInputAction.next,
                    labelText: "login_username".i18n(),
                    fillColor: isDark ? AppColors.secondaryGray : null,
                    onFieldSubmitted: (text) {
                      loginProvider.trimUsername();
                      passwordNode.requestFocus();
                    },
                    onChanged: (text) {
                      if (_formKey.currentState != null) {
                        _formKey.currentState!.validate();
                      }
                    },
                    autofillHints: const [AutofillHints.username],
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'login_form_empty_username'.i18n();
                      }
                      return null;
                    },
                  ),
                  BaseTextFormField(
                    controller: loginProvider.passwordController,
                    focusNode: passwordNode,
                    labelText: "login_password".i18n(),
                    fillColor: isDark ? AppColors.secondaryGray : null,
                    obscureText: true,
                    isPasswordField: true,
                    onFieldSubmitted: (value) => login(loginProvider, ref, context),
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.go,
                    onChanged: (text) {
                      if (_formKey.currentState != null) {
                        _formKey.currentState!.validate();
                      }
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'login_form_empty_password'.i18n();
                      }
                      return null;
                    },
                  ),
                  ref.watch(loginDataProvider).modelState == ModelState.error
                      ? Center(
                          child: Text(
                            ref.read(loginDataProvider).message,
                            style: const TextStyle(color: AppColors.errorRed),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                                onPressed: () {
                                  // TextInput.finishAutofillContext();
                                  login(loginProvider, ref, context);
                                },
                                child: Text(
                                  "login_login".i18n(),
                                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.white),
                                )),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                                style: ButtonStyle(
                                    side: WidgetStateProperty.resolveWith((state) => BorderSide.none),
                                    backgroundColor: WidgetStateColor.resolveWith((states) {
                                      // if (states.contains(WidgetState.focused) ||
                                      //     states.contains(WidgetState.pressed) ||
                                      //     states.contains(WidgetState.hovered)) {
                                      //   return AppColors.secondaryGray;
                                      // }
                                      return ref.watch(themeProvider) == AppThemeMode.dark
                                          ? Colors.black
                                          : AppColors.backgroundColor;
                                    })),
                                onPressed: () {
                                  if (ref.watch(loginDataProvider).username.isNotEmpty) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => ConfirmAlertDialog(
                                            onConfirm: () {
                                              ref.read(loginDataProvider.notifier).reset();
                                              context.pop();
                                            },
                                            title: "login_reset_password_confirm_title".i18n(),
                                            content:
                                                Text("login_reset_password_question".i18n(), textAlign: TextAlign.center))).then(
                                        (value) => ref.read(loginDataProvider).resetState == ModelState.success && context.mounted
                                            ? showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return SuccessAlertDialog(title: ref.read(loginDataProvider).message);
                                                }).then((value) => ref.read(loginDataProvider.notifier).clearResetState())
                                            : null);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            SuccessAlertDialog(title: "login_reset_password_username_title".i18n()));
                                  }
                                },
                                child: Text(
                                  "login_forgotten_password".i18n(),
                                  style: const TextStyle(color: AppColors.primary),
                                )),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                                style: ButtonStyle(
                                    side: WidgetStateProperty.resolveWith((state) => BorderSide.none),
                                    backgroundColor: WidgetStateColor.resolveWith((states) {
                                      // if (states.contains(WidgetState.focused) ||
                                      //     states.contains(WidgetState.pressed) ||
                                      //     states.contains(WidgetState.hovered)) {
                                      //   return AppColors.secondaryGray;
                                      // }
                                      return ref.watch(themeProvider) == AppThemeMode.dark
                                          ? Colors.black
                                          : AppColors.backgroundColor;
                                    })),
                                onPressed: () {
                                  _launchUrl();
                                },
                                child: Text(
                                  "login_login_guide".i18n(),
                                  style: const TextStyle(color: AppColors.primary),
                                )),
                          ),
                        ],
                      )),
                ]),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ))),
        ref.watch(loginDataProvider).modelState == ModelState.processing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox()
      ],
    );
  }

  Future<void> _launchUrl() async {
    var uri = Uri.parse("https://ungarn.brunstad.org/2024/10/dukapp/");
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView, webOnlyWindowName: "_blank")) {
      throw Exception('failed_to_open_uri:'.i18n([uri.toString()]));
    }
  }

  navigateTo(WidgetRef ref, BuildContext context) {
    if (ref.read(userDataProvider) == null) {
      ref
          .read(changePasswordDataProvider.notifier)
          .setUsername(ref.read(loginDataProvider).username, ref.read(loginDataProvider).password);
      context.push("/changePassword").then((success) {
        success != null && success as bool
            ? ref.read(loginDataProvider.notifier).clear("login_password_changed_success".i18n(), ModelState.error)
            : ref.read(loginDataProvider.notifier).clear("login_password_changed_failed".i18n(), ModelState.error);
      });
    } else {
      ref.read(loginDataProvider.notifier).clear();
      origRoute.isEmpty ? context.replace("/") : context.push(origRoute);
    }
  }

  Future<void> login(LoginDataNotifier loginProvider, WidgetRef ref, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await loginProvider.login().then((value) async =>
          ref.read(loginDataProvider).modelState == ModelState.success && context.mounted
              ? navigateTo(ref, context)
              : passwordNode.requestFocus());
    }
  }
}
