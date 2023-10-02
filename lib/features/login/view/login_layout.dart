import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';

class LoginLayout extends ConsumerWidget {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginProvider = ref.read(loginDataProvider.notifier);
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: const AssetImage("assets/logos/Work_black.png"),
                      fit: BoxFit.contain,
                      color: AppColors.primary,
                      height: 120.sp,
                    )
                  ],
                )),
            Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                      child: TextField(
                        controller: loginProvider.usernameController,
                        decoration: const InputDecoration(labelText: "Username"),
                      ),
                    ),
                    TextField(
                      controller: loginProvider.passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                  onPressed: () => loginProvider.login(),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.white),
                                  )),
                            ),
                          ],
                        )),
                    ref.watch(loginDataProvider).modelState == ModelState.error
                        ? const Center(
                            child: Text(
                              "Wrong username or password",
                              style: TextStyle(color: AppColors.errorRed),
                            ),
                          )
                        : const SizedBox()
                  ],
                )),
            const Text("Verzió: 1.0.0")
          ],
        ),
        ref.watch(loginDataProvider).modelState == ModelState.processing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox()
      ],
    );
  }
}
