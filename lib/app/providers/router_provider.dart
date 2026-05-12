import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activities/view/activities_page.dart';
import 'package:work_hu/features/activity_items/view/activity_items_page.dart';
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
import 'package:work_hu/features/donate_success_page/view/donate_payment_success_page.dart';
import 'package:work_hu/features/donation/view/donation_page.dart';
import 'package:work_hu/features/fra_kare_week/view/fra_kare_week_page.dart';
import 'package:work_hu/features/goal/view/goal_page.dart';
import 'package:work_hu/features/home/view/home_page.dart';
import 'package:work_hu/features/login/view/login_page.dart';
import 'package:work_hu/features/mentees/view/mentees_page.dart';
import 'package:work_hu/features/mentor_mentee/view/mentor_mentees_page.dart';
import 'package:work_hu/features/payment_success/view/payment_success_page.dart';
import 'package:work_hu/features/payments/view/payments_page.dart';
import 'package:work_hu/features/profile/view/language_picker_page.dart';
import 'package:work_hu/features/profile/view/profile_page.dart';
import 'package:work_hu/features/rounds/view/rounds_page.dart';
import 'package:work_hu/features/status/view/status_page.dart';
import 'package:work_hu/features/top_up/view/top_up_page.dart';
import 'package:work_hu/features/top_ups/view/top_ups_page.dart';
import 'package:work_hu/features/tos/view/privacy_policy.dart';
import 'package:work_hu/features/tos/view/tos_view.dart';
import 'package:work_hu/features/transaction_items/view/transaction_items_page.dart';
import 'package:work_hu/features/transactions/view/transactions_page.dart';
import 'package:work_hu/features/transfer_amount/view/transfer_amount_page.dart';
import 'package:work_hu/features/user_fra_kare_week/view/user_fra_kare_week_page.dart';
import 'package:work_hu/features/user_points/view/user_points_page.dart';
import 'package:work_hu/features/user_status/view/user_status_page.dart';
import 'package:work_hu/features/users/view/users_page.dart';

import '../../features/profile/view/theme_picker_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');
final _shellNavigatorAdminKey = GlobalKey<NavigatorState>(debugLabel: 'shellAdmin');
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorStatusKey = GlobalKey<NavigatorState>(debugLabel: 'shellStatus');
final routerProvider = Provider<GoRouter>((ref) {
  final userNotifier = ref.watch(userDataProvider);
  return GoRouter(
      refreshListenable: userNotifier,
      navigatorKey: navigatorKey,
      initialLocation: "/",
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
              navigatorKey: _shellNavigatorHomeKey,
              routes: [
                GoRoute(path: '/balance', builder: (context, state) => HomePage(), routes: [
                  GoRoute(path: "topUps", builder: (BuildContext context, GoRouterState state) => const TopUpsPage()),
                  GoRoute(path: "transfer", builder: (BuildContext context, GoRouterState state) => const TransferAmountPage()),
                ]),
              ],
            ),
            // Branch 2: Profile
            StatefulShellBranch(
              navigatorKey: _shellNavigatorProfileKey,
              routes: [
                GoRoute(path: '/profile', builder: (context, state) => const ProfilePage(), routes: [
                  GoRoute(
                      path: "activities",
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
                      ]),
                  GoRoute(
                    path: 'theme',
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
                    path: 'language',
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
                ]),
              ],
            ),

            // Branch 3: Admin
            StatefulShellBranch(
              navigatorKey: _shellNavigatorAdminKey,
              routes: [
                GoRoute(
                  path: '/admin',
                  builder: (context, state) => const AdminPage(),
                ),
              ],
            ),

            StatefulShellBranch(
              navigatorKey: _shellNavigatorStatusKey,
              routes: [
                GoRoute(path: '/status', builder: (context, state) => StatusPage()),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/tos',
          builder: (context, state) => const ToSPage(),
        ),
        GoRoute(
          path: '/privacy',
          builder: (context, state) => const PrivacyPolicy(),
        ),
        GoRoute(path: "/balance/topUp", builder: (BuildContext context, GoRouterState state) => TopUpPage(), routes: [
          GoRoute(
              path: "success/:checkout_reference",
              builder: (BuildContext context, GoRouterState state) {
                return PaymentSuccessPage(
                  checkoutReference: state.pathParameters["checkout_reference"],
                );
              }),
        ]),
        GoRoute(
            path: "/donate/:id",
            builder: (BuildContext context, GoRouterState state) => DonatePage(
                  id: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0,
                ),
            routes: [
              GoRoute(
                  path: "success/:checkout_reference",
                  builder: (BuildContext context, GoRouterState state) {
                    return DonatePaymentSuccessPage(
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
            path: '/change-password',
            builder: (BuildContext context, GoRouterState state) {
              return const ChangePasswordPage();
            }),
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
        final bool isPublicRoute = state.matchedLocation.startsWith('/login') ||
            state.matchedLocation.startsWith('/tos') ||
            state.matchedLocation.startsWith('/privacy') ||
            state.matchedLocation.startsWith('/donate'); // Crucial for your success page

        if (loggedIn && !user.changedPassword) {
          return '/change-password';
        }

        // If the user isn't logged in AND it's not a public route, kick to login
        if (!loggedIn && !isPublicRoute) {
          return '/login';
        }

        if (loggedIn && state.matchedLocation == '/') {
          return '/balance';
        }
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
          currentIndex: navigationShell.currentIndex,
          items: user!.isUser() ? userScreens() : adminScreens(),
          onTap: _goBranch,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> userScreens() => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.account_balance_wallet),
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: 'nav_bar_home'.i18n()),
        // BottomNavigationBarItem(
        //     activeIcon: const Icon(Icons.bar_chart), icon: const Icon(Icons.bar_chart_outlined), label: 'nav_bar_status'.i18n()),
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.person_2_rounded),
            icon: const Icon(Icons.person_2_outlined),
            label: 'nav_bar_profile'.i18n()),
      ];

  List<BottomNavigationBarItem> adminScreens() => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.account_balance_wallet),
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: 'nav_bar_home'.i18n()),
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.person_2_rounded),
            icon: const Icon(Icons.person_2_outlined),
            label: 'nav_bar_profile'.i18n()),
        // BottomNavigationBarItem(
        //     activeIcon: const Icon(Icons.bar_chart), icon: const Icon(Icons.bar_chart_outlined), label: 'nav_bar_status'.i18n()),
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.admin_panel_settings),
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: 'nav_bar_admin'.i18n())
      ];
}
