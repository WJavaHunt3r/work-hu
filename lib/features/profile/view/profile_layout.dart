import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
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
                  ref.watch(profileDataProvider).userGoal == null
                      ? const SizedBox()
                      : ref.watch(profileDataProvider).modelState == ModelState.processing
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              height: 135.sp * 2,
                              child: TabView(
                                user: user,
                                userRounds: ref.watch(profileDataProvider).userRounds,
                              )),
                  BaseTextFormField(
                    labelText: "user_details_email".i18n(),
                    enabled: false,
                    initialValue: user.email ?? "", onChanged: (String text) {},
                    // onChanged: (String text) => text.isNotEmpty
                    //     ? ref.watch(usersDataProvider.notifier).updateCurrentUser(user.copyWith(email: text))
                    //     : null,
                  ),
                  BaseTextFormField(
                    labelText: "user_details_phone_number".i18n(),
                    enabled: false,
                    initialValue: user.phoneNumber == null ? "" : user.phoneNumber.toString(),
                    keyBoardType: TextInputType.number,
                    onChanged: (String text) {},
                    // onChanged: (String text) => text.isNotEmpty
                    //     ? ref
                    //     .watch(usersDataProvider.notifier)
                    //     .updateCurrentUser(user.copyWith(phoneNumber: num.tryParse(text) ?? 0))
                    //     : null,
                  ),
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
                        child: Text("profile_logout".i18n(),
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))),
                  ))
                ],
              )
            ],
          );
  }
}
