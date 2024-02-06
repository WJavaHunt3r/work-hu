import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';

class LoginLayout extends ConsumerWidget {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginProvider = ref.read(loginDataProvider.notifier);
    // return Stack(
    //   children: [
        return

            Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage("assets/logos/Work_black.png"),
                    fit: BoxFit.contain,
                    color: AppColors.primary,
                    height: 120.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                    child: TextField(
                      controller: loginProvider.usernameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Username"),
                    ),
                  ),
                  TextField(
                    controller: loginProvider.passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    onSubmitted: (value) => loginProvider.login(),
                    textInputAction: TextInputAction.go,
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
                      ? Center(
                          child: Text(
                            ref.read(loginDataProvider).message,
                            style: const TextStyle(color: AppColors.errorRed),
                          ),
                        )
                      : const SizedBox()
              //   ],
              // ),

        ]);
    //     ref.watch(loginDataProvider).modelState == ModelState.processing
    //         ? const Center(
    //             child: CircularProgressIndicator(),
    //           )
    //         : const SizedBox()
    //   ],
    // );
  }
}
