import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
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
              ? teamLeaderScreens(context)
              : user.role == Role.ADMIN
                  ? [...teamLeaderScreens(context), ...adminLeaderScreens(context)]
                  : [],
    );
  }

  List<Widget> teamLeaderScreens(BuildContext context) => [
        createListTile(context: context, title: "admin_myshare_status", route: "userStatus"),
        createListTile(context: context, title: "admin_fra_kare_weeks", route: "fraKareWeeks"),
      ];

  List<Widget> adminLeaderScreens(BuildContext context) => [
        createListTile(context: context, title: "admin_activities", route: "activities"),
        createListTile(context: context, title: "admin_myshare_credits", route: "createTransaction"),
        createListTile(context: context, title: "admin_samvirk_credit", route: "createSamvirkTransaction"),
        createListTile(context: context, title: "admin_users", route: "users"),
        createListTile(context: context, title: "admin_goals", route: "goals"),
        createListTile(context: context, title: "admin_mentor_mentees", route: "mentorMentees"),
        createListTile(context: context, title: "admin_transactions", route: "transactions"),
        createListTile(context: context, title: "admin_camps", route: "camps"),
        createListTile(context: context, title: "admin_camp_registrations", route: "campRegistrations"),
        createListTile(context: context, title: "admin_rounds", route: "rounds"),
      ];

  Widget createListTile(
      {required BuildContext context, required String title, required String route, Object? extra, bool? enabled}) {
    return MenuOptionsListTile(
        title: title.i18n(),
        enabled: enabled ?? true,
        onTap: () => context.push(
              "/admin/$route",
              extra: extra,
            ));
  }
}
