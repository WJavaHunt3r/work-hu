import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
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
      physics: const NeverScrollableScrollPhysics(),
      children: user == null ? [] : _tiles(context, user),
    );
  }

  /// Every entry is shown to admins (as before) and to anyone holding the permission it needs.
  List<Widget> _tiles(BuildContext context, UserModel user) {
    bool can(Permission permission) => user.isAdmin() || user.hasPermission(permission);

    final entries = <({String label, IconData icon, String route})>[
      if (user.isAdmin() || user.isTeamLeader())
        (label: "admin_myshare_status", icon: Icons.bar_chart_outlined, route: "/admin/userStatus"),
      if (can(Permission.TRANSACTION_MANAGE))
        (label: "admin_myshare_credits", icon: Icons.account_balance_outlined, route: "/admin/createTransaction"),
      if (can(Permission.USER_MANAGE) || can(Permission.ROLE_MANAGE))
        (label: "admin_users", icon: Icons.group_outlined, route: "/admin/users"),
      if (can(Permission.ROLE_MANAGE))
        (label: "admin_roles", icon: Icons.admin_panel_settings_outlined, route: "/admin/roles"),
      if (can(Permission.GOAL_MANAGE)) (label: "admin_goals", icon: Icons.gps_fixed, route: "/admin/goals"),
      if (can(Permission.MENTOR_MANAGE))
        (label: "admin_mentor_mentees", icon: Icons.group_add_outlined, route: "/admin/mentorMentees"),
      if (can(Permission.TRANSACTION_MANAGE))
        (label: "admin_transactions", icon: Icons.list_alt, route: "/admin/transactions"),
      if (can(Permission.DONATION_MANAGE))
        (label: "admin_donations", icon: Icons.add_circle_outline, route: "/admin/donations"),
      if (can(Permission.PAYMENT_MANAGE))
        (label: "admin_payments", icon: Icons.payments_outlined, route: "/admin/payments"),
      if (can(Permission.CAMP_MANAGE)) (label: "admin_camps", icon: Icons.map_outlined, route: "/admin/camps"),
      if (can(Permission.CAMP_MANAGE))
        (label: "admin_camp_registrations", icon: Icons.app_registration, route: "/admin/campRegistrations"),
      if (can(Permission.SEASON_MANAGE)) (label: "admin_rounds", icon: Icons.timelapse, route: "/admin/rounds"),
      if (can(Permission.AUDIT_LOG_VIEW)) (label: "admin_audit_log", icon: Icons.history, route: "/admin/auditLog"),
    ];

    return [
      for (var i = 0; i < entries.length; i++)
        SettingsTile(
          label: entries[i].label.i18n(),
          icon: entries[i].icon,
          onTap: () => context.push(entries[i].route),
          index: i,
          isLast: i == entries.length - 1,
        ),
    ];
  }

  Widget createListTile({
    required BuildContext context,
    required String title,
    required String route,
    Object? extra,
    bool? enabled,
    bool? isLast,
    int? index,
  }) {
    return BaseListTile(
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      enabled: enabled ?? true,
      title: Text(title.i18n()),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () => context.push("/admin/$route", extra: extra),
      isLast: isLast ?? false,
      index: index ?? 1,
    );
  }

  @override
  StateNotifierProvider<AdminDataNotifier, AdminState> get provider => adminDataProvider;

  @override
  BaseState get status => throw UnimplementedError();
}
