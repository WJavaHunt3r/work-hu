import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      navigatorKey: GlobalKey<NavigatorState>(),
      initialLocation: "/",
      routes: <GoRoute>[
        GoRoute(
            path: '/',
            pageBuilder: (BuildContext context, GoRouterState state) => NoTransitionPage(child: HomePage()),
            routes: [
              GoRoute(
                  path: "donate/:id",
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
            ]),
        GoRoute(
            path: '/home',
            pageBuilder: (BuildContext context, GoRouterState state) => NoTransitionPage(child: HomePage()),
            routes: [
              GoRoute(
                  path: "donate/:id",
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
            ]),
        GoRoute(
          path: '/login',
          pageBuilder: (BuildContext context, GoRouterState state) {
            var map = state.extra == null ? null : state.extra as Map<String, dynamic>;
            return NoTransitionPage(child: LoginPage(origRoute: map == null ? "" : map["origRoute"] ?? "/"));
          },
        ),
        GoRoute(
            path: '/profile',
            pageBuilder: (BuildContext context, GoRouterState state) => const NoTransitionPage(child: ProfilePage()),
            routes: [
              GoRoute(
                path: 'userPoints/:id',
                pageBuilder: (BuildContext context, GoRouterState state) => NoTransitionPage(
                    child: UserPointsPage(
                  userId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0,
                )),
              ),
              GoRoute(
                  path: 'bufe/:id',
                  builder: (BuildContext context, GoRouterState state) {
                    var map = state.extra == null ? null : state.extra as Map<String, dynamic>;
                    return BufePage(
                      id: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0,
                      onTrack: map != null ? map["onTrack"] : null,
                    );
                  },
                  routes: [
                    GoRoute(path: "orderItems", builder: (BuildContext context, GoRouterState state) => OrderItems()),
                    GoRoute(
                        path: "cardFill",
                        builder: (BuildContext context, GoRouterState state) {
                          return CardFillPage(bufeId: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0);
                        },
                        routes: [
                          GoRoute(
                              path: "success/:checkout_reference",
                              builder: (BuildContext context, GoRouterState state) {
                                return PaymentSuccessPage(
                                    checkoutReference: state.pathParameters["checkout_reference"],
                                    bufeId: num.tryParse(state.pathParameters["id"] ?? "0"));
                              }),
                        ])
                  ]),
            ]),
        GoRoute(path: "/donation", builder: (BuildContext context, GoRouterState state) => const DonationsPage()),
        GoRoute(
            path: '/admin',
            pageBuilder: (BuildContext context, GoRouterState state) => const NoTransitionPage(child: AdminPage()),
            routes: [
              GoRoute(path: "activities", builder: (BuildContext context, GoRouterState state) => const ActivitiesPage()),
              GoRoute(
                  path: "createTransaction",
                  builder: (BuildContext context, GoRouterState state) => const CreateTransactionPage()),
              GoRoute(
                  path: "fraKareWeeks",
                  builder: (BuildContext context, GoRouterState state) => const FraKareWeekPage(),
                  routes: [
                    GoRoute(
                        path: ":id",
                        builder: (BuildContext context, GoRouterState state) =>
                            UserFraKareWeekPage(weekNumber: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0))
                  ]),
              GoRoute(
                  path: "createSamvirkTransaction",
                  builder: (BuildContext context, GoRouterState state) => const CreateSamvirkTransactionPage()),
              GoRoute(
                  path: "createPointsTransaction",
                  builder: (BuildContext context, GoRouterState state) => const CreatePointsTransactionPage()),
              GoRoute(path: "userStatus", builder: (BuildContext context, GoRouterState state) => const UserStatusPage()),
              GoRoute(path: "users", builder: (BuildContext context, GoRouterState state) => const UsersPage()),
              GoRoute(path: "goals", builder: (BuildContext context, GoRouterState state) => const GoalPage()),
              GoRoute(path: "rounds", builder: (BuildContext context, GoRouterState state) => const RoundsPage()),
              GoRoute(path: "donations", builder: (BuildContext context, GoRouterState state) => const DonationsPage()),
              GoRoute(
                  path: "payments",
                  builder: (BuildContext context, GoRouterState state) {
                    var map = state.extra == null ? null : state.extra as Map<String, dynamic>;
                    return PaymentsPage(
                      donationId: map != null ? map["donationId"] : null,
                      userId: map != null ? map["userId"] : null,
                    );
                  }),
              GoRoute(path: "mentorMentees", builder: (BuildContext context, GoRouterState state) => const MentorMenteesPage()),
              GoRoute(
                  path: "transactions",
                  builder: (BuildContext context, GoRouterState state) => const TransactionsPage(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (BuildContext context, GoRouterState state) {
                        return const TransactionItemsPage();
                      },
                    ),
                  ])
            ]),
        GoRoute(
            path: '/changePassword',
            builder: (BuildContext context, GoRouterState state) {
              return const ChangePasswordPage();
            }),
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
        UserModel? user = ref.read(userDataProvider);
        try {
          user ??= await ref.read(loginDataProvider.notifier).loginWithSavedData();
        } on DioException {
          user = null;
        }
        if (user == null) {
          if (([...userScreens, ...teamLeaderScreens].contains(state.matchedLocation) ||
              state.matchedLocation.contains("/admin/"))) {
            return "/login?origRoute=${state.matchedLocation}";
          } else {
            return null;
          }
        }

        if (state.matchedLocation.contains("/login")) {
          return "/profile";
        }

        if ((teamLeaderScreens.contains(state.matchedLocation) || state.matchedLocation.contains("/admin/fraKareWeeks/")) &&
            user.isTeamLeader()) {
          return state.matchedLocation;
        }

        if (state.matchedLocation.contains("/admin/") && !user.isAdmin()) {
          return "/home";
        }

        return state.matchedLocation;
      });
});

List<String> teamLeaderScreens = ["/admin", "/admin/userStatus", "/admin/fraKareWeeks", "/admin/fraKareWeeks/"];

List<String> userScreens = ["/profile", "/createActivity", "/userPoints", "/mentees", "/activities"];
