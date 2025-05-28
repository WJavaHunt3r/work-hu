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
      padding: EdgeInsets.all(8.sp),
      child: Row(
        mainAxisAlignment: user.paceTeam != null ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
        children: [
          spouse == null
              ? Text(
                  user.getFullName(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
                )
              : Text("${user.getFullName()}\n${spouse.getFullName()}",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800)),
          user.paceTeam != null
              ? Container(
                  width: 50.sp,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: Image.asset(
                    user.paceTeam!.iconAssetPath.toString(),
                    color: Color(int.parse("0x${user.paceTeam!.color}")),
                  ))
              : const SizedBox()
        ],
      ),
    );
  }
}
