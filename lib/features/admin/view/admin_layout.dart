import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/app/widgets/menu_options_list_tile.dart';
import 'package:work_hu/dukapp.dart';

class AdminLayout extends ConsumerWidget {
  const AdminLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userDataProvider);
    return ListView(
      children: user == null
          ? []
          : user.role == Role.TEAM_LEADER
              ? teamLeaderScreens(ref)
              : user.role == Role.ADMIN
                  ? [...teamLeaderScreens(ref), ...adminLeaderScreens(ref)]
                  : [],
    );
  }

  List<Widget> teamLeaderScreens(WidgetRef ref) => [
        createListTile(ref: ref, title: "admin_myshare_status", route: "userStatus"),
        createListTile(ref: ref, title: "admin_fra_kare_weeks", route: "fraKareWeeks"),
      ];

  List<Widget> adminLeaderScreens(WidgetRef ref) => [
        createListTile(ref: ref, title: "admin_activities", route: "activities"),
        createListTile(ref: ref, title: "admin_myshare_credits", route: "createTransaction"),
        createListTile(ref: ref, title: "admin_samvirk_credit", route: "createSamvirkTransaction"),
        createListTile(ref: ref, title: "admin_users", route: "users"),
        createListTile(ref: ref, title: "admin_goals", route: "goals"),
        createListTile(ref: ref, title: "admin_mentor_mentees", route: "mentorMentees"),
        createListTile(ref: ref, title: "admin_transactions", route: "transactions"),
        createListTile(ref: ref, title: "admin_camps", route: "camps"),
        createListTile(ref: ref, title: "admin_camp_registrations", route: "campRegistrations"),
        createListTile(ref: ref, title: "admin_rounds", route: "rounds"),
      ];

  Widget createListTile(
      {required WidgetRef ref, required String title, required String route, Object? extra, bool? enabled}) {
    return MenuOptionsListTile(
        title: title.i18n(),
        enabled: enabled ?? true,
        onTap: () => ref.read(routerProvider).push(
              "/admin/$route",
              extra: extra,
            ));
  }
}
