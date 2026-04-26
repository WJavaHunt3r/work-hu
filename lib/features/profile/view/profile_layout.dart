import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/menu_options_list_tile.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/widgets/profile_header.dart';
import 'package:work_hu/features/profile/widgets/profile_tab_view.dart';
import 'package:work_hu/features/profile/widgets/user_status_widget.dart';
import 'package:work_hu/features/users/widgets/user_details.dart';
import 'package:work_hu/features/utils.dart';

class ProfileLayout extends ConsumerStatefulWidget {
  const ProfileLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends ConsumerState<ProfileLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      ref.read(profileDataProvider.notifier).getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userDataProvider).user;
    var statuses = ref.watch(profileDataProvider).statuses;
    return user == null
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  const ProfileHeader(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(12.sp),
                          padding: EdgeInsets.symmetric(vertical: 6.sp),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.sp),
                              border: Border.all(color: Theme.of(context).colorScheme.primary)),
                          child: Text(
                            Utils.getMonthFromDate(DateTime.now(), context),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (statuses.isNotEmpty)
                    Column(children: [
                      for (var child in statuses)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.sp),
                          child: UserStatusWidget(
                              userRound:
                                  ref.watch(profileDataProvider).userRounds.where((ur) => ur.user.id == child.user.id).first,
                              key: widget.key,
                              titleText: child.user.getFullName(),
                              userStatus: statuses.firstWhere((g) => g.user.id == child.user.id)),
                        )
                    ]),
                  // SizedBox(
                  //   height: 4.sp,
                  // ),
                  // ref.watch(profileDataProvider).fraKareWeeks.isEmpty ? const SizedBox() : const FraKareStreak(),
                  Column(
                    children: [
                      if (user.bufeId != null)
                        MenuOptionsListTile(
                            title: "profile_bufe_title".i18n([user.getFullName()]),
                            onTap: () {
                              var userStatus = statuses.where((statusUser) => statusUser.user.id == user.id);
                              var status = userStatus.length == 1 ? userStatus.first : null;
                              context.push("/profile/bufe/${user.id}", extra: {"onTrack": status?.onTrack ?? true});
                            }),
                      if (ref.watch(profileDataProvider).spouse?.bufeId != null)
                        MenuOptionsListTile(
                            title: "profile_bufe_title".i18n([ref.watch(profileDataProvider).spouse!.getFullName()]),
                            onTap: () {
                              var id = ref.read(profileDataProvider).spouse!.id;
                              var userStatus =
                                  statuses.where((statusUser) => statusUser.user.id == ref.watch(profileDataProvider).spouse!.id);
                              var status = userStatus.length == 1 ? userStatus.first : null;
                              context.push(
                                  Uri(
                                    path: "/profile/bufe/$id",
                                  ).toString(),
                                  extra: {"onTrack": status?.onTrack ?? true});
                            }),
                      for (var child in ref.watch(profileDataProvider).children)
                        if (child.bufeId != null)
                          MenuOptionsListTile(
                              title: "profile_bufe_title".i18n([child.getFullName()]),
                              onTap: () {
                                var userStatus = statuses.where((c) => c.id == child.id);
                                if (userStatus.length == 1) {
                                  context.push(Uri(path: "/profile/bufe/${child.id}").toString(),
                                      extra: {"onTrack": userStatus.first.onTrack});
                                } else {
                                  context.push(Uri(
                                    path: "/profile/bufe/${child.id}",
                                  ).toString());
                                }
                              }),
                      MenuOptionsListTile(
                          title: "profile_details_title".i18n(),
                          onTap: () => showGeneralDialog(
                              barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                              barrierColor: Theme.of(context).colorScheme.primary,
                              transitionDuration: const Duration(milliseconds: 200),
                              context: context,
                              pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                                return UserDetails(
                                  user: user,
                                  enabled: false,
                                );
                              })),
                      Visibility(
                          visible: user.isMentor(),
                          child:
                              MenuOptionsListTile(title: "profile_mentees_title".i18n(), onTap: () => context.push("/mentees"))),
                      Visibility(
                          visible: user.isMentor(),
                          child: MenuOptionsListTile(
                              title: "profile_activities_title".i18n(), onTap: () => context.push("/activities"))),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => ConfirmAlertDialog(
                                      onConfirm: () {
                                        ref.read(profileDataProvider.notifier).logout();
                                        context.pop();
                                        context.replace("/");
                                      },
                                      title: "profile_logout_confirm_title".i18n(),
                                      content: Text(
                                        "profile_logout_question".i18n(),
                                        textAlign: TextAlign.center,
                                      )));
                            },
                            child: Text("profile_logout".i18n(), style: Theme.of(context).textTheme.titleMedium)),
                      ))
                    ],
                  )
                ],
              )),
            ],
          );
  }
}
