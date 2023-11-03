import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_page.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';
import 'package:work_hu/features/utils.dart';

class ProfileGrid extends ConsumerWidget {
  const ProfileGrid({required this.user, required this.userRoundModel, super.key});

  final UserModel user;
  final UserRoundModel userRoundModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NumberFormat numberFormat = NumberFormat("#,###");
    final NumberFormat pointsFormat = NumberFormat("#,###.#");
    return Column(children: [
      Row(
        children: [
          Expanded(
              child: InfoCard(
                  height: 100.sp,
                  padding: 10.sp,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text("${numberFormat.format(user.currentMyShareCredit / user.goal * 100)}%",
                                style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w800)),
                          ),
                          if (userRoundModel.myShareOnTrackPoints)
                            Align(
                              alignment: Alignment.topRight,
                              child: Image(
                                image: AssetImage("assets/img/myshare-logo.png"),
                                fit: BoxFit.fitWidth,
                                height: 20.sp,
                              ),
                            )
                        ],
                      ),
                      Text("MyShare Status", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  onTap: () => showGeneralDialog(
                      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                      barrierColor: AppColors.primary,
                      transitionDuration: const Duration(milliseconds: 200),
                      context: context,
                      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                        return MyShareStatusPage(user:user);
                      }))),
          SizedBox(
            width: 12.sp,
          ),
          Expanded(
            child: InfoCard(
                height: 100.sp,
                padding: 10.sp,
                onTap: () =>
                    context.push("/userPoints").then((value) => ref.read(profileDataProvider.notifier).getUserInfo()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pointsFormat.format(userRoundModel.roundPoints),
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
            child: InfoCard(
                height: 100.sp,
                padding: 10.sp,
                onTap: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text("${pointsFormat.format(userRoundModel.samvirkPayments)} Ft",
                                style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w800),
                                textScaler: TextScaler.linear(
                                  Utils.textScaleFactor(context),
                                ))),
                        if (userRoundModel.samvirkOnTrackPoints)
                          Align(
                            alignment: Alignment.topRight,
                            child: Image(
                              image: AssetImage("assets/img/Samvirk_logo.png"),
                              fit: BoxFit.fitWidth,
                              height: 20.sp,
                            ),
                          )
                      ],
                    ),
                    Text(
                      "Samvirk payments",
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
          ),
        ],
      )
    ]);
  }
}
