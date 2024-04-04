import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userDataProvider)!;
    var spouse = ref.watch(profileDataProvider).spouse;
    return Column(
      children: [
        user.team == null
            ? Icon(
                Icons.person_outline,
                size: 100.sp,
              )
            : SvgPicture.asset(
                "assets/logos/${user.team!.color}_vacduka.svg",
                height: 120.sp,
                fit: BoxFit.contain,
              ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sp),
            child: spouse == null
                ? Text(
                    user.getFullName(),
                    style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w800),
                  )
                : Text("${user.getFullName()}\n${spouse.getFullName()}",
                    style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w800)))
      ],
    );
  }
}
