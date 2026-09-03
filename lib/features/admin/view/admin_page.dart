import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/settings_tile.dart';
import 'package:work_hu/features/admin/data/state/admin_state.dart';
import 'package:work_hu/features/admin/providers/admin_provider.dart';

import '../../../app/widgets/base_list_item.dart';

class AdminPage extends BasePage {
  const AdminPage({super.key, super.title = "Admin"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AdminPageState();
  }
}

class AdminPageState extends BasePageState<AdminPage, AdminState, AdminDataNotifier> {
  @override
  Widget buildLayout() {
    var user = locator<UserProvider>().user;
    return BaseListView(
      hasBottomPadding: false,
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
        SettingsTile(
            label: "admin_myshare_status".i18n(),
            icon: Icons.bar_chart_outlined,
            onTap: () => context.push(
                  "/admin/userStatus",
                ),
            index: 0),
        // createListTile(context: context, title: "admin_myshare_status", route: "userStatus"),
        // createListTile(context: context, title: "admin_fra_kare_weeks", route: "fraKareWeeks"),
        // createListTile(context: context, title: "admin_statistics", route: "statistics", enabled: false, isLast: true),
      ];

  List<Widget> adminLeaderScreens(BuildContext context) => [
        // createListTile(context: context, title: "admin_activities", route: "activities"),
        SettingsTile(
            label: "admin_myshare_credits".i18n(),
            icon: Icons.account_balance_outlined,
            onTap: () => context.push(
                  "/admin/createTransaction",
                ),
            index: 0),
        // createListTile(context: context, title: "admin_myshare_credits", route: "createTransaction"),
        // createListTile(context: context, title: "admin_samvirk_credit", route: "createSamvirkTransaction"),
        // createListTile(context: context, title: "admin_points", route: "createPointsTransaction"),
        SettingsTile(
            label: "admin_users".i18n(),
            icon: Icons.group_outlined,
            onTap: () => context.push(
                  "/admin/users",
                )),
        // createListTile(context: context, title: "admin_users", route: "users"),
        SettingsTile(
            label: "admin_goals".i18n(),
            icon: Icons.gps_fixed,
            onTap: () => context.push(
                  "/admin/goals",
                )),
        // createListTile(context: context, title: "admin_goals", route: "goals"),
        SettingsTile(
            label: "admin_mentor_mentees".i18n(),
            icon: Icons.group_add_outlined,
            onTap: () => context.push(
                  "/admin/mentorMentees",
                )),
        // createListTile(context: context, title: "admin_mentor_mentees", route: "mentorMentees"),
        SettingsTile(
            label: "admin_transactions".i18n(),
            icon: Icons.list_alt,
            onTap: () => context.push(
                  "/admin/transactions",
                )),
        // createListTile(context: context, title: "admin_transactions", route: "transactions"),
        SettingsTile(
            label: "admin_donations".i18n(),
            icon: Icons.add_circle_outline,
            onTap: () => context.push(
                  "/admin/donations",
                )),
        // createListTile(context: context, title: "admin_donations", route: "donations"),
        SettingsTile(
            label: "admin_payments".i18n(),
            icon: Icons.payments_outlined,
            onTap: () => context.push(
                  "/admin/payments",
                )),
        // createListTile(context: context, title: "admin_payments", route: "payments"),
        SettingsTile(
            label: "admin_camps".i18n(),
            icon: Icons.map_outlined,
            onTap: () => context.push(
                  "/admin/camps",
                )),
        // createListTile(context: context, title: "admin_camps", route: "camps"),
        SettingsTile(
            label: "admin_camp_registrations".i18n(),
            icon: Icons.app_registration,
            onTap: () => context.push(
                  "/admin/campRegistrations",
                )),
        // createListTile(context: context, title: "admin_camp_registrations", route: "campRegistrations"),
        SettingsTile(
            label: "admin_rounds".i18n(),
            icon: Icons.timelapse,
            isLast: true,
            onTap: () => context.push(
                  "/admin/rounds",
                )),
        // createListTile(context: context, title: "admin_rounds", route: "rounds", isLast: true),
      ];

  Widget createListTile(
      {required BuildContext context,
      required String title,
      required String route,
      Object? extra,
      bool? enabled,
      bool? isLast,
      int? index}) {
    return BaseListTile(
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      enabled: enabled ?? true,
      title: Text(title.i18n()),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () => context.push(
        "/admin/$route",
        extra: extra,
      ),
      isLast: isLast ?? false,
      index: index ?? 1,
    );
  }

  @override
  AutoDisposeStateNotifierProvider<AdminDataNotifier, AdminState> get provider => adminDataProvider;

  @override
  BaseState get status => throw UnimplementedError();
}
