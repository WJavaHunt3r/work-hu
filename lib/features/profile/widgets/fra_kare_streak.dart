import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';

class FraKareStreak extends ConsumerWidget {
  const FraKareStreak({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        margin: EdgeInsets.only(bottom: 2.sp),
        child: Padding(
          padding: EdgeInsets.all(8.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "profile_fra_kare_week_title".i18n(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  Text("profile_fra_kare_streak_count".i18n([
                    ref.read(profileDataProvider).fraKareWeeks.where((e) => e.listened).length.toString(),
                    ref.read(profileDataProvider).fraKareWeeks.length.toString()
                  ]))
                ],
              ),
              SizedBox(
                height: 110.sp,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: ref.watch(profileDataProvider).fraKareWeeks.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = ref.watch(profileDataProvider).fraKareWeeks[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 8.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "profile_week_number".i18n([item.fraKareWeek.weekNumber.toString()]),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              height: 75.sp,
                              width: 75.sp,
                              decoration: BoxDecoration(
                                // shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(12.sp),
                                image: DecorationImage(
                                    image: const AssetImage("assets/img/fra_kare_til_buk.jpeg"),
                                    fit: BoxFit.fitWidth,
                                    opacity: item.listened ? 1.0 : 0.5),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
