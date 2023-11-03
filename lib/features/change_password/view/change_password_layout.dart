import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/change_password/provider/change_password_provider.dart';

class ChangePasswordLayout extends ConsumerWidget {
  const ChangePasswordLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(children: [
      Card(
          child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(8.sp),
              child: Text("Fill in the form", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.sp),
              child: TextField(
                controller: ref.watch(changePasswordDataProvider.notifier).usernameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Username"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.sp),
              child: TextField(
                obscureText: true,
                controller: ref.watch(changePasswordDataProvider.notifier).passwordController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Old password"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.sp),
              child: TextField(
                obscureText: true,
                controller: ref.watch(changePasswordDataProvider.notifier).newPasswordController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "New password"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.sp),
              child: TextField(
                obscureText: true,
                controller: ref.watch(changePasswordDataProvider.notifier).newPasswordAgainController,
                textInputAction: TextInputAction.go,
                decoration: const InputDecoration(labelText: "New password again"),
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
            Padding(
              padding: EdgeInsets.only(top: 4.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => ref.read(changePasswordDataProvider.notifier).changePassword(),
                      child: const Text(
                        "Change password",
                        style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.white),
                      )),
                ],
              ),
            )
          ],
        ),
      )),
      ref.watch(changePasswordDataProvider).modelState == ModelState.processing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox()
    ]);
  }
}
