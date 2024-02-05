import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';
import 'package:work_hu/features/home/widgets/error_view.dart';
import 'package:work_hu/features/home/widgets/status_view.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';

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
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(top: 8.sp),
        child: Column(
          children: [
            Expanded(
                child: ref.watch(teamRoundDataProvider).modelState == ModelState.processing
                    ? const Center(child: CircularProgressIndicator())
                    : ref.watch(teamRoundDataProvider).modelState == ModelState.error
                        ? const ErrorView()
                        : StatusView(teamRounds: ref.watch(teamRoundDataProvider).teams)),
          ],
        ),
      ),
      RefreshIndicator(
          onRefresh: () async => ref.watch(teamRoundDataProvider.notifier).getTeamRounds(), child: SizedBox.expand())
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
