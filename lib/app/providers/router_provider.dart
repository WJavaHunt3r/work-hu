import 'package:flutter/cupertino.dart' show CupertinoTabBar;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/notifications/deep_link.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activities/view/activities_page.dart';
import 'package:work_hu/features/audit_log/view/audit_log_page.dart';
import 'package:work_hu/features/job_chat/view/job_chat_page.dart';
import 'package:work_hu/features/jobs/view/job_detail_page.dart';
import 'package:work_hu/features/mailing/view/mailing_history_page.dart';
import 'package:work_hu/features/mailing/view/mailing_page.dart';
import 'package:work_hu/features/streams/providers/streams_provider.dart';
import 'package:work_hu/features/streams/view/live_page.dart';
import 'package:work_hu/features/streams/view/streams_page.dart';
import 'package:work_hu/features/jobs/view/jobs_calendar_page.dart';
import 'package:work_hu/features/login/widgets/complete_name_dialog.dart';
import 'package:work_hu/features/jobs/view/job_form_page.dart';
import 'package:work_hu/features/jobs/view/jobs_page.dart';
import 'package:work_hu/features/roles/data/model/app_role_model.dart';
import 'package:work_hu/features/roles/view/role_edit_page.dart';
import 'package:work_hu/features/roles/view/roles_page.dart';
import 'package:work_hu/features/activity_items/view/activity_items_page.dart';
import 'package:work_hu/features/admin/view/admin_page.dart';
import 'package:work_hu/features/bufe_transactions/view/bufe_transactions_page.dart';
import 'package:work_hu/features/camps/view/camps_page.dart';
import 'package:work_hu/features/change_password/view/change_password_page.dart';
import 'package:work_hu/features/create_activity/view/create_activity_page.dart';
import 'package:work_hu/features/create_transactions/view/create_point_transactions_page.dart';
import 'package:work_hu/features/create_transactions/view/create_samvirk_transactions_page.dart';
import 'package:work_hu/features/create_transactions/view/create_transaction_page.dart';
import 'package:work_hu/features/donate/view/donate_page.dart';
import 'package:work_hu/features/donate_success_page/view/donate_payment_success_page.dart';
import 'package:work_hu/features/donation/view/donation_page.dart';
import 'package:work_hu/features/fra_kare_week/view/fra_kare_week_page.dart';
import 'package:work_hu/features/goal/view/goal_page.dart';
import 'package:work_hu/features/home/view/home_page.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/login/view/login_page.dart';
import 'package:work_hu/features/mentees/view/mentees_page.dart';
import 'package:work_hu/features/mentor_mentee/view/mentor_mentees_page.dart';
import 'package:work_hu/features/payment_success/view/payment_success_page.dart';
import 'package:work_hu/features/payments/view/payments_page.dart';
import 'package:work_hu/features/notification_admin/data/model/notification_schedule_model.dart';
import 'package:work_hu/features/notification_admin/view/general_notifications_page.dart';
import 'package:work_hu/features/notification_admin/view/overdue_jobs_page.dart';
import 'package:work_hu/features/notification_admin/view/notification_schedules_page.dart';
import 'package:work_hu/features/notification_admin/view/schedule_edit_page.dart';
import 'package:work_hu/features/notification_admin/view/send_notification_page.dart';
import 'package:work_hu/features/notifications/view/notification_preferences_page.dart';
import 'package:work_hu/features/profile/view/language_picker_page.dart';
import 'package:work_hu/features/change_password/view/reset_password_page.dart';
import 'package:work_hu/features/profile/view/profile_details_page.dart';
import 'package:work_hu/features/profile/view/profile_page.dart';
import 'package:work_hu/features/profile/view/security_page.dart';
import 'package:work_hu/features/reading_plan/view/article_edit_page.dart';
import 'package:work_hu/features/reading_plan/view/article_reader_page.dart';
import 'package:work_hu/features/reading_plan/view/psalm_reader_page.dart';
import 'package:work_hu/features/reading_plan/view/psalms_page.dart';
import 'package:work_hu/features/reading_plan/view/reported_notes_page.dart';
import 'package:work_hu/features/bible/data/model/bible_model.dart' show parseVerseRange;
import 'package:work_hu/features/bible/view/bible_chapter_page.dart';
import 'package:work_hu/features/bible/view/bible_page.dart';
import 'package:work_hu/features/bible/view/bible_annotations_page.dart';
import 'package:work_hu/features/reading_plan/view/reading_plan_articles_admin_page.dart';
import 'package:work_hu/features/rounds/view/round_edit_page.dart';
import 'package:work_hu/features/rounds/view/rounds_page.dart';
import 'package:work_hu/features/start/view/start_page.dart';
import 'package:work_hu/features/status/view/status_page.dart';
import 'package:work_hu/features/top_up/view/top_up_page.dart';
import 'package:work_hu/features/top_ups/view/top_ups_page.dart';
import 'package:work_hu/features/tos/view/privacy_policy.dart';
import 'package:work_hu/features/tos/view/tos_view.dart';
import 'package:work_hu/features/transaction_items/view/transaction_items_page.dart';
import 'package:work_hu/features/transactions/view/transactions_page.dart';
import 'package:work_hu/features/transfer_amount/view/transfer_amount_page.dart';
import 'package:work_hu/features/user_fra_kare_week/view/user_fra_kare_week_page.dart';
import 'package:work_hu/features/user_status/view/user_status_page.dart';
import 'package:work_hu/features/user_transactions/view/user_transactions_page.dart';
import 'package:work_hu/features/users/view/users_page.dart';

import '../../features/profile/view/theme_picker_page.dart';
import 'package:work_hu/app/platform/adaptive.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorStartKey = GlobalKey<NavigatorState>(debugLabel: 'shellStart');
final _shellNavigatorAdminKey = GlobalKey<NavigatorState>(debugLabel: 'shellAdmin');
final _shellNavigatorLiveKey = GlobalKey<NavigatorState>(debugLabel: 'shellLive');
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorStatusKey = GlobalKey<NavigatorState>(debugLabel: 'shellStatus');
final _shellNavigatorJobsKey = GlobalKey<NavigatorState>(debugLabel: 'shellJobs');

/// Jobs used to live under /profile; links in notifications that were already sent still point there.
String _oldJobsLocation(BuildContext context, GoRouterState state) =>
    state.uri.toString().replaceFirst('/profile/jobs', '/jobs');
final routerProvider = Provider<GoRouter>((ref) {
  // read, not watch: watching the ChangeNotifier built a new router (back at /home) on every user change, e.g. after
  // saving the profile details; refreshListenable already re-runs the redirects
  final userNotifier = ref.read(userDataProvider);
  return GoRouter(
    refreshListenable: userNotifier,
    navigatorKey: navigatorKey,
    initialLocation: "/home",
    routes: [
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),

      // --- PROTECTED ROUTES (With Bottom Bar) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home, the first tab (live banner, reading challenge, the church's status, the Bible)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorStartKey,
            routes: [GoRoute(path: '/home', builder: (context, state) => const StartPage())],
          ),
          // Branch 1: Status
          StatefulShellBranch(
            navigatorKey: _shellNavigatorStatusKey,
            routes: [
              GoRoute(
                path: '/status',
                builder: (context, state) => StatusPage(),
                routes: [
                  GoRoute(
                    path: 'transactions/:id',
                    pageBuilder: (BuildContext context, GoRouterState state) => NoTransitionPage(
                      child: UserTransactionsPage(userId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Balance
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/balance',
                builder: (context, state) => HomePage(),
                routes: [
                  GoRoute(path: "topUps", builder: (BuildContext context, GoRouterState state) => const TopUpsPage()),
                  GoRoute(
                    path: "transfer",
                    builder: (BuildContext context, GoRouterState state) => const TransferAmountPage(),
                  ),
                  GoRoute(
                    path: "transactions",
                    builder: (BuildContext context, GoRouterState state) => const BufeTransactionsPage(),
                  ),
                ],
              ),
            ],
          ),
          // Branch 3: Jobs: registering for jobs. Creating and running them is in the admin (/admin/jobs).
          StatefulShellBranch(
            navigatorKey: _shellNavigatorJobsKey,
            routes: [
              GoRoute(
                path: '/jobs',
                builder: (context, state) => const JobsPage(),
                routes: [
                  // "calendar" must stay before ":id", or it is read as a job id
                  GoRoute(path: 'calendar', builder: (context, state) => const JobsCalendarPage()),
                  GoRoute(
                    path: ':id',
                    builder: (BuildContext context, GoRouterState state) =>
                        JobDetailPage(jobId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0),
                    routes: [
                      GoRoute(
                        path: 'chat',
                        builder: (BuildContext context, GoRouterState state) =>
                            JobChatPage(jobId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Branch 4: Admin
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAdminKey,
            routes: [GoRoute(path: '/admin', builder: (context, state) => const AdminPage())],
          ),

          // Branch 5: Live (only in the tab bar while a stream is on the air)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorLiveKey,
            routes: [GoRoute(path: '/live', builder: (context, state) => const LivePage())],
          ),
        ],
      ),
      // The profile: the tabs' avatar opens it as a sheet; /profile (links, notifications) opens it as a page, and its
      // pages are siblings with full paths, so they open above the sheet and back leads to it
      GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
      GoRoute(
        path: "/profile/activities",
        builder: (BuildContext context, GoRouterState state) => const ActivitiesPage(),
        routes: [
          GoRoute(
            path: ':id/items',
            builder: (BuildContext context, GoRouterState state) {
              return ActivityItemsPage(activityId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0);
            },
          ),
          GoRoute(
            path: 'createActivity',
            builder: (BuildContext context, GoRouterState state) => const CreateActivityPage(),
          ),
          GoRoute(
            path: ':id/edit',
            builder: (BuildContext context, GoRouterState state) =>
                CreateActivityPage(id: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0),
          ),
        ],
      ),
      GoRoute(
        path: "/profile/jobs",
        redirect: _oldJobsLocation,
        routes: [
          GoRoute(
            path: ':id',
            redirect: _oldJobsLocation,
            routes: [GoRoute(path: 'chat', redirect: _oldJobsLocation)],
          ),
        ],
      ),
      GoRoute(path: '/profile/details', builder: (context, state) => const ProfileDetailsPage()),
      GoRoute(path: '/profile/security', builder: (context, state) => const SecurityPage()),
      GoRoute(
        path: '/profile/notifications',
        builder: (BuildContext context, GoRouterState state) => const NotificationPreferencesPage(),
      ),
      GoRoute(
        path: '/profile/theme',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ThemePickerPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Animate from the bottom up
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(position: animation.drive(tween), child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/profile/language',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const LanguagePickerPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Animate from the bottom up
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(position: animation.drive(tween), child: child);
            },
          );
        },
      ),
      GoRoute(path: '/tos', builder: (context, state) => const ToSPage()),
      // The one-time link from the "forgot password" / admin reset e-mail
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => ResetPasswordPage(token: state.uri.queryParameters['token'] ?? ''),
      ),
      GoRoute(path: '/privacy', builder: (context, state) => const PrivacyPolicy()),
      GoRoute(
        path: "/balance/topUp",
        builder: (BuildContext context, GoRouterState state) => TopUpPage(),
        routes: [
          GoRoute(
            path: "success/:checkout_reference",
            builder: (BuildContext context, GoRouterState state) {
              return PaymentSuccessPage(checkoutReference: state.pathParameters["checkout_reference"]);
            },
          ),
        ],
      ),
      GoRoute(
        path: "/donate/:id",
        builder: (BuildContext context, GoRouterState state) =>
            DonatePage(id: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0),
        routes: [
          GoRoute(
            path: "success/:checkout_reference",
            builder: (BuildContext context, GoRouterState state) {
              return DonatePaymentSuccessPage(
                donationId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0,
                checkoutReference: state.pathParameters["checkout_reference"],
              );
            },
          ),
        ],
      ),

      GoRoute(
        path: '/change-password',
        builder: (BuildContext context, GoRouterState state) {
          return const ChangePasswordPage();
        },
      ),
      GoRoute(
        path: "/admin/createTransaction",
        builder: (BuildContext context, GoRouterState state) => const CreateTransactionPage(),
      ),
      GoRoute(
        path: "/admin/fraKareWeeks",
        builder: (BuildContext context, GoRouterState state) => const FraKareWeekPage(),
        routes: [
          GoRoute(
            path: ":id",
            builder: (BuildContext context, GoRouterState state) =>
                UserFraKareWeekPage(weekNumber: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0),
          ),
        ],
      ),
      GoRoute(
        path: "/admin/createSamvirkTransaction",
        builder: (BuildContext context, GoRouterState state) => const CreateSamvirkTransactionPage(),
      ),
      GoRoute(
        path: "/admin/createPointsTransaction",
        builder: (BuildContext context, GoRouterState state) => const CreatePointsTransactionPage(),
      ),
      GoRoute(
        path: "/admin/userStatus",
        builder: (BuildContext context, GoRouterState state) => const UserStatusPage(),
      ),
      GoRoute(path: "/admin/users", builder: (BuildContext context, GoRouterState state) => const UsersPage()),
      GoRoute(path: "/admin/roles", builder: (BuildContext context, GoRouterState state) => const RolesPage()),
      GoRoute(path: "/admin/auditLog", builder: (BuildContext context, GoRouterState state) => const AuditLogPage()),
      // Single page level each, like the roles routes. "create" must stay before ":id", or it is read as a job id.
      GoRoute(
        path: "/admin/jobs",
        builder: (BuildContext context, GoRouterState state) => const JobsPage(manage: true, title: "admin_jobs"),
      ),
      GoRoute(
        path: "/admin/jobs/calendar",
        builder: (BuildContext context, GoRouterState state) => const JobsCalendarPage(manage: true),
      ),
      GoRoute(path: "/admin/jobs/create", builder: (BuildContext context, GoRouterState state) => const JobFormPage()),
      GoRoute(
        path: "/admin/jobs/:id",
        builder: (BuildContext context, GoRouterState state) =>
            JobDetailPage(jobId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0, manage: true),
      ),
      GoRoute(
        path: "/admin/jobs/:id/chat",
        builder: (BuildContext context, GoRouterState state) =>
            JobChatPage(jobId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0),
      ),
      GoRoute(path: "/admin/mailing", builder: (BuildContext context, GoRouterState state) => const MailingPage()),
      GoRoute(
        path: "/admin/mailing/history",
        builder: (BuildContext context, GoRouterState state) => const MailingHistoryPage(),
      ),
      // The reading challenge: outside the tab shell, so users without a church (who have no Status page) can open it too
      GoRoute(
        path: '/psalms',
        builder: (context, state) => const PsalmsPage(),
        routes: [
          // "article/:id" must stay before ":n"
          GoRoute(
            path: 'article/:id',
            builder: (context, state) =>
                ArticleReaderPage(articleId: num.tryParse(state.pathParameters['id'] ?? '') ?? 0),
          ),
          GoRoute(
            path: ':n',
            builder: (context, state) => PsalmReaderPage(number: int.tryParse(state.pathParameters['n'] ?? '') ?? 1),
          ),
        ],
      ),
      // The Bible: outside the tab shell like the psalms, for every signed-in user
      GoRoute(
        path: '/bible',
        builder: (context, state) => const BiblePage(),
        routes: [
          // "notes" must stay before ":book/:chapter"
          GoRoute(path: 'notes', builder: (context, state) => const BibleAnnotationsPage()),
          GoRoute(
            path: ':book/:chapter',
            builder: (context, state) {
              final verses = parseVerseRange(state.uri.queryParameters['verse']);
              return BibleChapterPage(
                osis: state.pathParameters['book'] ?? 'Gen',
                chapter: int.tryParse(state.pathParameters['chapter'] ?? '') ?? 1,
                focusVerse: verses?.start,
                focusEnd: verses?.end,
              );
            },
          ),
        ],
      ),
      // The articles of the reading plan; "new" must stay before ":id"
      GoRoute(path: "/admin/readingPlan", builder: (context, state) => const ReadingPlanArticlesAdminPage()),
      GoRoute(path: "/admin/readingPlan/new", builder: (context, state) => const ArticleEditPage()),
      GoRoute(path: "/admin/readingPlan/reported", builder: (context, state) => const ReportedNotesPage()),
      GoRoute(
        path: "/admin/readingPlan/:id",
        builder: (context, state) => ArticleEditPage(id: num.tryParse(state.pathParameters["id"] ?? "")),
      ),
      GoRoute(path: "/admin/streams", builder: (BuildContext context, GoRouterState state) => const StreamsPage()),
      GoRoute(
        path: "/admin/notifications/overdueJobs",
        builder: (BuildContext context, GoRouterState state) => const OverdueJobsPage(),
      ),
      GoRoute(
        path: "/admin/jobs/:id/edit",
        builder: (BuildContext context, GoRouterState state) =>
            JobFormPage(jobId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0),
      ),
      GoRoute(
        path: "/admin/roles/edit",
        builder: (BuildContext context, GoRouterState state) => RoleEditPage(role: state.extra as AppRoleModel?),
      ),
      // "send" and "schedules" are siblings, not children: a single page level each, like the roles routes
      GoRoute(
        path: "/admin/notifications",
        builder: (BuildContext context, GoRouterState state) => const GeneralNotificationsPage(),
      ),
      GoRoute(
        path: "/admin/notifications/send",
        builder: (BuildContext context, GoRouterState state) => const SendNotificationPage(),
      ),
      GoRoute(
        path: "/admin/notifications/schedules",
        builder: (BuildContext context, GoRouterState state) => const NotificationSchedulesPage(),
      ),
      GoRoute(
        path: "/admin/notifications/schedules/edit",
        builder: (BuildContext context, GoRouterState state) =>
            ScheduleEditPage(schedule: state.extra as NotificationScheduleModel?),
      ),
      GoRoute(path: "/admin/goals", builder: (BuildContext context, GoRouterState state) => const GoalPage()),
      GoRoute(path: "/admin/rounds", builder: (BuildContext context, GoRouterState state) => const RoundsPage()),
      // "new" must stay before ":id", or it is read as a round id
      GoRoute(path: "/admin/rounds/new", builder: (BuildContext context, GoRouterState state) => const RoundEditPage()),
      GoRoute(
        path: "/admin/rounds/:id",
        builder: (BuildContext context, GoRouterState state) =>
            RoundEditPage(id: num.tryParse(state.pathParameters["id"] ?? "")),
      ),
      GoRoute(path: "/admin/donations", builder: (BuildContext context, GoRouterState state) => const DonationsPage()),
      GoRoute(path: "/admin/camps", builder: (BuildContext context, GoRouterState state) => const CampPage()),
      GoRoute(
        path: "/admin/payments",
        builder: (BuildContext context, GoRouterState state) {
          var map = state.extra == null ? null : state.extra as Map<String, dynamic>;
          return PaymentsPage(
            donationId: map != null ? map["donationId"] : null,
            userId: map != null ? map["userId"] : null,
          );
        },
      ),
      GoRoute(
        path: "/admin/mentorMentees",
        builder: (BuildContext context, GoRouterState state) => const MentorMenteesPage(),
      ),
      GoRoute(
        path: "/admin/transactions",
        builder: (BuildContext context, GoRouterState state) => const TransactionsPage(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (BuildContext context, GoRouterState state) {
              return TransactionItemsPage(transactionId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0);
            },
          ),
        ],
      ),

      GoRoute(
        path: '/mentees',
        builder: (BuildContext context, GoRouterState state) {
          return const MenteesPage();
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      var user = userNotifier.user;
      final bool loggedIn = user != null;

      // Use startsWith to catch sub-routes like /donate/12/success/...
      final bool isPublicRoute =
          state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/tos') ||
          state.matchedLocation.startsWith('/privacy') ||
          state.matchedLocation.startsWith('/donate') || // Crucial for your success page
          state.matchedLocation.startsWith('/reset-password');

      // A reset link works whoever is signed in on this device (it ends at the login page anyway)
      if (state.matchedLocation.startsWith('/reset-password')) return null;

      if (loggedIn && !user.changedPassword) {
        return '/change-password';
      }

      // If the user isn't logged in AND it's not a public route, kick to login
      if (!loggedIn && !isPublicRoute) {
        // Remember where they were heading (deep link / notification) so login can continue there.
        DeepLink.remember(state.uri.toString());
        return '/login';
      }

      if (loggedIn && user.changedPassword && DeepLink.hasPending) {
        return DeepLink.consume();
      }

      // Signed in (e.g. just now on the login page): nothing to do on /login any more
      if (loggedIn && state.matchedLocation.startsWith('/login')) return '/home';

      // Users outside a church only have Home (with the Bible), the balance and the profile.
      if (loggedIn && !user.hasChurch()) {
        final location = state.matchedLocation;
        if (location == '/' || ['/status', '/jobs', '/admin', '/live'].any(location.startsWith)) return '/home';
        if (location.startsWith('/profile/activities')) return '/home';
      }

      if (loggedIn && state.matchedLocation == '/') {
        return '/home';
      }
      return null;
    },
  );
});

List<String> teamLeaderScreens = ["/admin", "/admin/userStatus", "/admin/fraKareWeeks", "/admin/fraKareWeeks/"];

List<String> userScreens = ["/profile", "/createActivity", "/userPoints", "/mentees", "/activities", "/bufe"];

class ScaffoldWithNestedNavigation extends ConsumerWidget {
  const ScaffoldWithNestedNavigation({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Navigate to the initial location of the branch if switching tabs
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  /// The tabs this user sees, each with the index of its branch in the shell route. Hidden tabs leave gaps, so an
  /// item's position in the bar is not its branch index.
  List<({int branch, BottomNavigationBarItem item})> _tabs(UserModel user, {required bool showLive}) {
    final church = user.hasChurch();
    return [
      (
        branch: 0,
        item: BottomNavigationBarItem(
          activeIcon: const Icon(Icons.home),
          icon: const Icon(Icons.home_outlined),
          label: 'nav_bar_start'.i18n(),
        ),
      ),
      if (church)
        (
          branch: 1,
          item: BottomNavigationBarItem(
            activeIcon: const Icon(Icons.bar_chart_outlined),
            icon: const Icon(Icons.bar_chart_outlined),
            label: 'nav_bar_status'.i18n(),
          ),
        ),
      (
        branch: 2,
        item: BottomNavigationBarItem(
          activeIcon: const Icon(Icons.account_balance_wallet),
          icon: const Icon(Icons.account_balance_wallet_outlined),
          label: 'nav_bar_home'.i18n(),
        ),
      ),
      if (church)
        (
          branch: 3,
          item: BottomNavigationBarItem(
            activeIcon: const Icon(Icons.work),
            icon: const Icon(Icons.work_outline),
            label: 'nav_bar_jobs'.i18n(),
          ),
        ),
      if (church && showLive)
        (
          branch: 5,
          item: BottomNavigationBarItem(
            activeIcon: const Icon(Icons.sensors),
            icon: const Icon(Icons.sensors),
            label: 'nav_bar_live'.i18n(),
          ),
        ),
      if (church && user.hasAdminAccess())
        (
          branch: 4,
          item: BottomNavigationBarItem(
            activeIcon: const Icon(Icons.admin_panel_settings),
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: 'nav_bar_admin'.i18n(),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider).user;
    // The Live tab is there while something is on the air, and stays while it is open
    final onAir = ref.watch(liveStreamsProvider).value?.isNotEmpty ?? false;
    final tabs = _tabs(user!, showLive: onAir || navigationShell.currentIndex == 5);
    final selected = tabs.indexWhere((t) => t.branch == navigationShell.currentIndex);
    return Scaffold(
      // The navigation shell contains the page for the current branch; the gate asks for a missing name first
      body: CompleteNameGate(child: navigationShell),
      // The iOS app gets the native tab bar, Android and the web keep the rounded Material one
      bottomNavigationBar: useCupertino(context)
          ? CupertinoTabBar(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Theme.of(context).hintColor,
              currentIndex: selected < 0 ? 0 : selected,
              items: [for (final t in tabs) t.item],
              onTap: (i) => _goBranch(tabs[i].branch),
            )
          : Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24.sp), topRight: Radius.circular(24.sp)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5.sp, // How soft the shadow is
                    spreadRadius: 0, // How far the shadow extends
                    color: Colors.black.withValues(alpha: 0.15), // Shadow color
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                enableFeedback: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                // The router keeps users off hidden tabs; the fallback only covers the frame before it redirects.
                currentIndex: selected < 0 ? 0 : selected,
                items: [for (final t in tabs) t.item],
                onTap: (i) => _goBranch(tabs[i].branch),
              ),
            ),
    );
  }
}
