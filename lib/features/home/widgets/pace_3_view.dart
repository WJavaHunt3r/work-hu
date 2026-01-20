import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/home/providers/home_provider.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';

class Pace3View extends BasePage {
  const Pace3View({super.key, super.title = "", super.isListView = true, super.extendBodyBehindAppBar = true});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    var users = ref.watch(homeDataProvider).users;
    var curRound = ref.watch(roundDataProvider).currentRound;
    return curRound == null
        ? SizedBox()
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              var curUser = users[index];

              if (curUser.status * 100 >= curRound.localMyShareGoal!) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8.sp, left: 4.sp, right: 4.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFffd700), // gold
                        Color(0xFFdaa520), // goldenrod
                        Color(0xFFb8860b), // darkgoldenrod
                      ],
                      stops: [0.1, 0.5, 0.9],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: ListTile(
                      tileColor: Colors.transparent,
                      title: Text(users[index].user.getFullName(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                      trailing: Text(
                        "> ${curRound.localMyShareGoal.toString()} %",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                      )),
                );
              } else {
                return Container(
                  margin: EdgeInsets.only(bottom: 8.sp, left: 4.sp, right: 4.sp),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.sp),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                        offset: const Offset(0, 2),
                      )
                    ],
                    gradient: curUser.onTrack
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              // gold
                              AppColors.primaryGreen, // goldenrod
                              AppColors.primary100,
                              AppColors.primary, // darkgoldenrod
                            ],
                            stops: [0.1, 0.5, 0.9],
                          )
                        : null,
                  ),
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Text(users[index].user.getFullName(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: curUser.onTrack ? Colors.white : AppColors.primary)),
                    trailing: Text(
                      curUser.onTrack ? " > ${curRound.myShareGoal} %" : "",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          );
  }
}
