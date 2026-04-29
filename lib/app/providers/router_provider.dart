import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activities/view/activities_page.dart';
import 'package:work_hu/features/activity_items/view/activity_items_layout.dart';
import 'package:work_hu/features/admin/view/admin_page.dart';
import 'package:work_hu/features/bufe/view/bufe_page.dart';
import 'package:work_hu/features/bufe/widgets/order_items.dart';
import 'package:work_hu/features/card_fill/view/card_fill_page.dart';
import 'package:work_hu/features/change_password/view/change_password_page.dart';
import 'package:work_hu/features/create_activity/view/create_activity_page.dart';
import 'package:work_hu/features/create_transactions/view/create_point_transactions_page.dart';
import 'package:work_hu/features/create_transactions/view/create_samvirk_transactions_page.dart';
import 'package:work_hu/features/create_transactions/view/create_transaction_page.dart';
import 'package:work_hu/features/donate/view/donate_page.dart';
import 'package:work_hu/features/donation/view/donation_page.dart';
import 'package:work_hu/features/fra_kare_week/view/fra_kare_week_page.dart';
import 'package:work_hu/features/goal/view/goal_page.dart';
import 'package:work_hu/features/home/view/home_page.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/login/view/login_page.dart';
import 'package:work_hu/features/mentees/view/mentees_page.dart';
import 'package:work_hu/features/mentor_mentee/view/mentor_mentees_page.dart';
import 'package:work_hu/features/payment_success/view/payment_success_page.dart';
import 'package:work_hu/features/payments/view/payments_page.dart';
import 'package:work_hu/features/profile/view/profile_page.dart';
import 'package:work_hu/features/rounds/view/rounds_page.dart';
import 'package:work_hu/features/transaction_items/view/transaction_items_page.dart';
import 'package:work_hu/features/transactions/view/transactions_page.dart';
import 'package:work_hu/features/user_fra_kare_week/view/user_fra_kare_week_page.dart';
import 'package:work_hu/features/user_points/view/user_points_page.dart';
import 'package:work_hu/features/user_status/view/user_status_page.dart';
import 'package:work_hu/features/users/view/users_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final routerProvider = Provider<GoRouter>((ref) {
  final userNotifier = ref.watch(userDataProvider);
  return GoRouter(
      refreshListenable: userNotifier,
      navigatorKey: navigatorKey,
      initialLocation: "/home",
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),

        // --- PROTECTED ROUTES (With Bottom Bar) ---
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
          },
          branches: [
            // Branch 1: User Status (The default page after login)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/status',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
            // Branch 2: Profile
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),

            // Branch 3: Admin
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/admin',
                  builder: (context, state) => const AdminPage(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
            path: "/donate/:id",
            builder: (BuildContext context, GoRouterState state) => DonatePage(
                  id: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0,
                ),
            routes: [
              GoRoute(
                  path: "success/:checkout_reference",
                  builder: (BuildContext context, GoRouterState state) {
                    return PaymentSuccessPage(
                      checkoutReference: state.pathParameters["checkout_reference"],
                    );
                  }),
            ]),
        GoRoute(
          path: '/profile/userPoints/:id',
          pageBuilder: (BuildContext context, GoRouterState state) => NoTransitionPage(
              child: UserPointsPage(
            userId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0,
          )),
        ),
        GoRoute(
            path: '/profile/changePassword',
            builder: (BuildContext context, GoRouterState state) {
              return const ChangePasswordPage();
            }),
        GoRoute(
            path: '/profile/bufe/:id',
            builder: (BuildContext context, GoRouterState state) {
              return BufePage(
                onTrack: true,
                userId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0,
              );
            },
            routes: [
              GoRoute(path: "orderItems", builder: (BuildContext context, GoRouterState state) => OrderItems()),
              GoRoute(
                  path: "cardFill",
                  builder: (BuildContext context, GoRouterState state) {
                    return CardFillPage(userId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0);
                  },
                  routes: [
                    GoRoute(
                        path: "success/:checkout_reference(.*)",
                        builder: (BuildContext context, GoRouterState state) {
                          return PaymentSuccessPage(checkoutReference: state.pathParameters["checkout_reference"]);
                        }),
                  ])
            ]),
        GoRoute(path: "/donation", builder: (BuildContext context, GoRouterState state) => const DonationsPage()),
        GoRoute(path: "/admin/activities", builder: (BuildContext context, GoRouterState state) => const ActivitiesPage()),
        GoRoute(
            path: "/admin/createTransaction",
            builder: (BuildContext context, GoRouterState state) => const CreateTransactionPage()),
        GoRoute(
            path: "/admin/fraKareWeeks",
            builder: (BuildContext context, GoRouterState state) => const FraKareWeekPage(),
            routes: [
              GoRoute(
                  path: ":id",
                  builder: (BuildContext context, GoRouterState state) =>
                      UserFraKareWeekPage(weekNumber: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0))
            ]),
        GoRoute(
            path: "/admin/createSamvirkTransaction",
            builder: (BuildContext context, GoRouterState state) => const CreateSamvirkTransactionPage()),
        GoRoute(
            path: "/admin/createPointsTransaction",
            builder: (BuildContext context, GoRouterState state) => const CreatePointsTransactionPage()),
        GoRoute(path: "/admin/userStatus", builder: (BuildContext context, GoRouterState state) => const UserStatusPage()),
        GoRoute(path: "/admin/users", builder: (BuildContext context, GoRouterState state) => const UsersPage()),
        GoRoute(path: "/admin/goals", builder: (BuildContext context, GoRouterState state) => const GoalPage()),
        GoRoute(path: "/admin/rounds", builder: (BuildContext context, GoRouterState state) => const RoundsPage()),
        GoRoute(path: "/admin/donations", builder: (BuildContext context, GoRouterState state) => const DonationsPage()),
        GoRoute(
            path: "/admin/payments",
            builder: (BuildContext context, GoRouterState state) {
              var map = state.extra == null ? null : state.extra as Map<String, dynamic>;
              return PaymentsPage(
                donationId: map != null ? map["donationId"] : null,
                userId: map != null ? map["userId"] : null,
              );
            }),
        GoRoute(path: "/admin/mentorMentees", builder: (BuildContext context, GoRouterState state) => const MentorMenteesPage()),
        GoRoute(
            path: "/admin/transactions",
            builder: (BuildContext context, GoRouterState state) => const TransactionsPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (BuildContext context, GoRouterState state) {
                  return const TransactionItemsPage();
                },
              ),
            ]),
        GoRoute(
          path: '/createActivity',
          builder: (BuildContext context, GoRouterState state) => const CreateActivityPage(),
        ),
        GoRoute(
          path: '/activity/:id',
          builder: (BuildContext context, GoRouterState state) {
            return ActivityItemsLayout(activityId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0);
          },
        ),
        GoRoute(
          path: '/mentees',
          builder: (BuildContext context, GoRouterState state) {
            return const MenteesPage();
          },
        ),
        GoRoute(path: "/activities", builder: (BuildContext context, GoRouterState state) => const ActivitiesPage())
      ],
      redirect: (BuildContext context, GoRouterState state) async {
        final bool loggedIn = userNotifier.user != null;
        final bool loggingIn = state.matchedLocation == '/login';

        // 1. If not logged in and not on home, force go home
        if (!loggedIn) {
          return loggingIn ? null : '/login';
        }

        // 2. If logged in and trying to go home, send to status
        // if (loggingIn) {
        //   return '/status';
        // }

        return null;
      });
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider).user;
    return Scaffold(
      body: navigationShell, // The navigation shell contains the page for the current branch
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          // Use theme's card color
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          // Standard card corner radius
          boxShadow: [
            BoxShadow(
              // The key to a top shadow is a negative y-offset
              offset: const Offset(0, -5),
              blurRadius: 10.0, // How soft the shadow is
              spreadRadius: 0, // How far the shadow extends
              color: Colors.black.withValues(alpha: 0.15), // Shadow color
            ),
          ],
        ),
        child: BottomNavigationBar(
          enableFeedback: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: navigationShell.currentIndex,
          items: user == null
              ? noUserScreens()
              : user.isUser()
                  ? userScreens()
                  : adminScreens(),
          onTap: _goBranch,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> noUserScreens() => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.run_circle_rounded),
            icon: const Icon(Icons.run_circle_outlined),
            label: 'myshare_status_status'.i18n()),
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.login), icon: const Icon(Icons.login_outlined), label: 'login_title'.i18n()),
      ];

  List<BottomNavigationBarItem> userScreens() => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.run_circle_rounded),
            icon: const Icon(Icons.run_circle_outlined),
            label: 'myshare_status_status'.i18n()),
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.person_2_rounded),
            icon: const Icon(Icons.person_2_outlined),
            label: 'profile_title'.i18n()),
      ];

  List<BottomNavigationBarItem> adminScreens() => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.run_circle_rounded),
            icon: const Icon(Icons.run_circle_outlined),
            label: 'myshare_status_status'.i18n()),
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.person_2_rounded),
            icon: const Icon(Icons.person_2_outlined),
            label: 'profile_title'.i18n()),
        const BottomNavigationBarItem(
            activeIcon: Icon(Icons.admin_panel_settings), icon: Icon(Icons.admin_panel_settings_outlined), label: 'Admin')
      ];
}
