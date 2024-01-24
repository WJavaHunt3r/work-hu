import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/widgets/profile_header.dart';
import 'package:work_hu/features/profile/widgets/tab_view.dart';

class ProfileLayout extends ConsumerWidget {
  const ProfileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userDataProvider);

    return user == null
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: ListView(
                children: [
                  const ProfileHeader(),
                  TabView(user: user),
                ],
              )),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(bottom: 8.sp),
                    child: TextButton(
                        onPressed: () {
                          ref.read(profileDataProvider.notifier).logout();
                          context.pop();
                        },
                        style: ButtonStyle(
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                        ),
                        child: const Text("Logout",
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))),
                  ))
                ],
              )
            ],
          );
  }
}
