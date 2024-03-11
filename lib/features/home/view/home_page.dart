import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';
import 'package:work_hu/features/home/widgets/error_view.dart';
import 'package:work_hu/features/home/widgets/status_view.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/utils.dart';

class HomePage extends BasePage {
  const HomePage({super.key, super.title = "Work HU", super.isListView = true});

  @override
  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    return [ModelState.error, ModelState.processing].contains(ref.watch(teamRoundDataProvider).modelState)
        ? []
        : ref.watch(userDataProvider) == null
            ? [
                IconButton(
                    onPressed: () => context.push("/login").then((value) => ref.refresh(teamRoundDataProvider)),
                    icon: const Icon(Icons.login))
              ]
            : [
                IconButton(
                    onPressed: () {
                      ref.watch(profileDataProvider.notifier).getUserGoal();
                      context.push("/profile").then((value) => ref.refresh(teamRoundDataProvider));
                    },
                    icon: const Icon(Icons.perm_identity_rounded))
              ];
  }

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
                          .i18n([Utils.dateToStringWithTime(currentRound.endDateTime.add(Duration(minutes: 1)))]),
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
