import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/user_provider.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userDataProvider)!;
    return Column(
      children: [
        user.team == null
            ? Icon(
                Icons.person_outline,
                size: 100.sp,
              )
            : Image(
                image: AssetImage("assets/logos/WORK_${user.team!.color}_black_Vácduka.png"),
                fit: BoxFit.contain,
                height: 120.sp,
              ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sp),
            child: Text(
              "${user.firstname} ${user.lastname}",
              style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w800),
            ))
      ],
    );
  }
}
