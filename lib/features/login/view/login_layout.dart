import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/success_alert_dialog.dart';
import 'package:work_hu/features/change_password/provider/change_password_provider.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';

class LoginLayout extends ConsumerWidget {
  const LoginLayout({required this.origRoute, super.key});

  final String origRoute;
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginProvider = ref.watch(loginDataProvider.notifier);
    return Stack(
      children: [
        SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: AutofillGroup(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                    child: TextFormField(
                      controller: loginProvider.usernameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: "login_username".i18n()),
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
                  ),
                  TextFormField(
                    controller: loginProvider.passwordController,
                    decoration: InputDecoration(labelText: "login_password".i18n()),
                    obscureText: true,
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
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                                style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) {
                                  if (states.contains(WidgetState.focused) ||
                                      states.contains(WidgetState.pressed) ||
                                      states.contains(WidgetState.hovered)) {
                                    return Colors.grey.shade500.withOpacity(0.3);
                                  }
                                  return Colors.transparent;
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
                                            content: Text("login_reset_password_question".i18n()))).then((value) => ref
                                                .read(loginDataProvider)
                                                .resetState ==
                                            ModelState.success
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
                                onPressed: () {
                                  login(loginProvider, ref, context);
                                },
                                child: Text(
                                  "login_login".i18n(),
                                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.white),
                                )),
                          ),
                        ],
                      )),
                  ref.watch(loginDataProvider).modelState == ModelState.error
                      ? Center(
                          child: Text(
                            ref.read(loginDataProvider).message,
                            style: const TextStyle(color: AppColors.errorRed),
                          ),
                        )
                      : const SizedBox()
                  //   ],
                  // ),
                ])))),
        ref.watch(loginDataProvider).modelState == ModelState.processing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox()
      ],
    );
  }

  navigateTo(WidgetRef ref, BuildContext context) {
    if (ref.read(userDataProvider) == null) {
      ref.read(changePasswordDataProvider.notifier).setUsername(ref.read(loginDataProvider).username);
      context.push("/changePassword", extra: {"username": ref.read(loginDataProvider).username}).then((success) {
        success != null && success as bool
            ? ref.read(loginDataProvider.notifier).clear("login_password_changed_success".i18n(), ModelState.error)
            : ref.read(loginDataProvider.notifier).clear("login_password_changed_failed".i18n(), ModelState.error);
      });
    } else {
      origRoute.isEmpty ? context.pop() : context.push(origRoute);
    }
  }

  void login(LoginDataNotifier loginProvider, WidgetRef ref, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      loginProvider.login().then((value) async =>
          ref.read(loginDataProvider).modelState == ModelState.success ? navigateTo(ref, context) : null);
    }
  }
}
