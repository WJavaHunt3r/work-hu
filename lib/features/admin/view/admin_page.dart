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
        createListTile(context: context, title: "admin_myshare_status", route: "userStatus", index: 0),
        createListTile(context: context, title: "admin_fra_kare_weeks", route: "fraKareWeeks"),
        createListTile(context: context, title: "admin_statistics", route: "statistics", enabled: false, isLast: true),
      ];

  List<Widget> adminLeaderScreens(BuildContext context) => [
        createListTile(context: context, title: "admin_activities", route: "activities"),
        createListTile(context: context, title: "admin_myshare_credits", route: "createTransaction"),
        createListTile(context: context, title: "admin_samvirk_credit", route: "createSamvirkTransaction"),
        createListTile(context: context, title: "admin_points", route: "createPointsTransaction"),
        createListTile(context: context, title: "admin_users", route: "users"),
        createListTile(context: context, title: "admin_goals", route: "goals"),
        createListTile(context: context, title: "admin_mentor_mentees", route: "mentorMentees"),
        createListTile(context: context, title: "admin_transactions", route: "transactions"),
        createListTile(context: context, title: "admin_donations", route: "donations"),
        createListTile(context: context, title: "admin_payments", route: "payments"),
        createListTile(context: context, title: "admin_camps", route: "camps"),
        createListTile(context: context, title: "admin_camp_registrations", route: "campRegistrations"),
        createListTile(context: context, title: "admin_rounds", route: "rounds", isLast: true),
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
