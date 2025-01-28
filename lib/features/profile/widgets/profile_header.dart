import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userDataProvider)!;
    var spouse = ref.watch(profileDataProvider).spouse;
    return Padding(
        padding: EdgeInsets.only(bottom: 8.sp),
        child: spouse == null
            ? Text(
                user.getFullName(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
              )
            : Text("${user.getFullName()}\n${spouse.getFullName()}",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800)));
  }
}
