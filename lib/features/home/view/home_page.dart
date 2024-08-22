import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/main_screen.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';
import 'package:work_hu/features/home/widgets/error_view.dart';
import 'package:work_hu/features/home/widgets/status_view.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/utils.dart';

class HomePage extends MainScreen {
  const HomePage({super.key, super.title = "PACE", super.centerTitle = true})
      : super(
            selectedIndex: 0,
            appBarTextStyle: const TextStyle(fontFamily: "Good-Timing", fontWeight: FontWeight.bold, fontSize: 35));

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    var currentRound = ref.watch(roundDataProvider).rounds.isNotEmpty
        ? ref.watch(roundDataProvider).rounds.firstWhere((element) =>
            element.startDateTime.compareTo(DateTime.now()) < 0 && element.endDateTime.compareTo(DateTime.now()) > 0)
        : null;
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(top: 8.sp),
        child: Column(
          children: [
            currentRound != null &&
                    currentRound.freezeDateTime.compareTo(DateTime.now()) < 0 &&
                    currentRound.endDateTime.compareTo(DateTime.now()) >= 0 &&
                    ref.watch(userDataProvider)?.id != 255
                ? Center(
                    child: Text(
                      "home_status_freeze"
                          .i18n([Utils.dateToStringWithTime(currentRound.endDateTime.add(const Duration(minutes: 1)))]),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Expanded(
                    child: ref.watch(teamRoundDataProvider).modelState == ModelState.processing
                        ? const Center(child: CircularProgressIndicator())
                        : ref.watch(teamRoundDataProvider).modelState == ModelState.error
                            ? const ErrorView()
                            : StatusView(teamRounds: ref.watch(teamRoundDataProvider).teams)),
          ],
        ),
      ),
    ]);
  }

  @override
  Widget? createActionButton(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataProvider)?.isMentor() ?? false
        ? FloatingActionButton(
            onPressed: () => context.push("/createActivity"),
            child: const Icon(Icons.add),
          )
        : null;
  }
}
