import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/change_password/provider/change_password_provider.dart';

class ChangePasswordLayout extends ConsumerWidget {
  const ChangePasswordLayout({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(children: [
      Padding(
          padding: EdgeInsets.all(8.sp),
          child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.sp),
                      child: TextFormField(
                        controller: ref.watch(changePasswordDataProvider.notifier).usernameController,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                        decoration: InputDecoration(labelText: "change_password_username".i18n()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.sp),
                      child: TextFormField(
                        obscureText: true,
                        autofillHints: const [AutofillHints.password],
                        controller: ref.watch(changePasswordDataProvider.notifier).passwordController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: "change_password_old_password".i18n()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.sp),
                      child: TextFormField(
                        obscureText: true,
                        controller: ref.watch(changePasswordDataProvider.notifier).newPasswordController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: "change_password_new_password".i18n()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.sp),
                      child: TextFormField(
                        obscureText: true,
                        controller: ref.watch(changePasswordDataProvider.notifier).newPasswordAgainController,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(labelText: "change_password_new_password_again".i18n()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () => ref.read(changePasswordDataProvider.notifier).changePassword().then(
                                  (value) => ref.read(changePasswordDataProvider).modelState == ModelState.success
                                      ? context.canPop() ? context.pop(true) : context.push("/login")
                                      : null),
                              child: Text(
                                "change_password_change_action".i18n(),
                                style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.white),
                              )),
                        ],
                      ),
                    ),
                    ref.watch(changePasswordDataProvider).modelState == ModelState.error
                        ? Center(
                            child: Text(
                              ref.watch(changePasswordDataProvider).message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.errorRed),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ))),
      ref.watch(changePasswordDataProvider).modelState == ModelState.processing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox()
    ]);
  }
}
