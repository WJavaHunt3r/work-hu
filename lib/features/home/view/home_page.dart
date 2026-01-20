import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/main_screen.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/home/providers/home_provider.dart';
import 'package:work_hu/features/home/widgets/error_view.dart';
import 'package:work_hu/features/home/widgets/pace_3_view.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/utils.dart';

class HomePage extends MainScreen {
  HomePage({super.key, super.title = "home_unboxing", super.centerTitle = true})
      : super(selectedIndex: 0, appBarTextStyle: TextStyle(fontSize: 22.sp, fontFamily: "Good-Timing"));

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    RoundModel? currentRound;
    try {
      currentRound = ref.watch(roundDataProvider).currentRound;
    } catch (e) {
      currentRound = null;
    }

    return Stack(children: [
      Column(
        children: [
          currentRound != null &&
                  currentRound.freezeDateTime.compareTo(DateTime.now()) < 0 &&
                  currentRound.endDateTime.compareTo(DateTime.now()) >= 0 &&
                  (ref.watch(userDataProvider) == null ||
                      ref.watch(userDataProvider) != null && ref.watch(userDataProvider)!.isUser())
              ? Center(
                  child: Text(
                    "home_status_freeze"
                        .i18n([Utils.dateToStringWithTime(currentRound.endDateTime.add(const Duration(minutes: 1)))]),
                    textAlign: TextAlign.center,
                  ),
                )
              : Expanded(child: ref.watch(homeDataProvider).modelState == ModelState.error ? const ErrorView() : Pace3View()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var donation in ref.watch(homeDataProvider).donations)
                SizedBox(
                  width: 200.sp,
                  child: Card(
                      margin: EdgeInsets.only(bottom: 8.sp, top: 8.sp),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.sp, left: 4.sp, right: 4.sp),
                              child: Text(donation.description.toString()),
                            ),
                            TextButton(
                                onPressed: () => context.push("/donate/${donation.id}"),
                                child: Text("home_donation_button".i18n(), style: const TextStyle(color: Colors.white))),
                          ],
                        ),
                      )),
                )
            ],
          )
        ],
      ),
    ]);
  }

  @override
  Widget? createActionButton(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataProvider)?.isMentor() ?? false
        ? FloatingActionButton(
            elevation: 0,
            onPressed: () => context.push("/createActivity"),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.sp)),
            child: const Icon(Icons.add),
          )
        : null;
  }
}
