import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';

import '../../../app/user_service.dart';

class ProfileLayout extends ConsumerWidget {
  const ProfileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NumberFormat numberFormat = NumberFormat("#,###.#");
    final user = locator<UserService>().currentUser;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            user!.team == null
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
        ),
        Row(
          children: [
            Expanded(
                child: InfoCard(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(numberFormat.format(user.currentMyShareCredit),
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
                    Container(
                      height: 1.sp,
                      color: AppColors.primary,
                    ),
                    Text(numberFormat.format(user.goal),
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
                  ],
                ),
                Text("MyShare Status", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600)),
              ],
            ))),
            SizedBox(
              width: 12.sp,
            ),
            Expanded(
              child: InfoCard(
                  onTap: () => context.push("/userPoints"),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(numberFormat.format(user.points),
                          style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w800)),
                      Text(
                        "Points",
                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: TextButton(
                    onPressed: () {
                      locator<UserService>().setUser(null);
                      context.pop();
                    },
                    style: ButtonStyle(
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                    ),
                    child:
                        const Text("Logout", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))))
          ],
        )
      ],
    );
  }
}
