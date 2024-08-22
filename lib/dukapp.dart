import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/style/app_style.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/activities/view/activities_page.dart';
import 'package:work_hu/features/activity_items/view/activity_items_layout.dart';
import 'package:work_hu/features/admin/view/admin_page.dart';
import 'package:work_hu/features/change_password/view/change_password_page.dart';
import 'package:work_hu/features/create_activity/view/create_activity_page.dart';
import 'package:work_hu/features/create_transactions/view/create_transaction_page.dart';
import 'package:work_hu/features/goal/view/goal_page.dart';
import 'package:work_hu/features/home/view/home_page.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/login/view/login_page.dart';
import 'package:work_hu/features/mentees/view/mentees_page.dart';
import 'package:work_hu/features/mentor_mentee/view/mentor_mentees_page.dart';
import 'package:work_hu/features/transaction_items/view/transaction_items_page.dart';
import 'package:work_hu/features/transactions/view/transactions_page.dart';
import 'package:work_hu/features/user_points/view/user_points_page.dart';
import 'package:work_hu/features/user_status/view/user_status_page.dart';
import 'package:work_hu/features/users/view/users_page.dart';

import 'features/profile/view/profile_page.dart';

class DukApp extends ConsumerWidget {
  const DukApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterWebFrame(
      backgroundColor: AppColors.backgroundColor,
      builder: (context) {
        return ScreenUtilInit(
            // designSize: const Size(360, 690),
            minTextAdapt: true,
            ensureScreenSize: true,
            splitScreenMode: false,
            builder: (context, child) {
              final theme = GlobalTheme();
              final router = ref.watch(routerProvider);
              LocalJsonLocalization.delegate.directories = ['lib/I18n'];
              return MaterialApp.router(
                scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
                debugShowCheckedModeBanner: false,
                title: 'DukApp',
                theme: theme.globalTheme,
                routerConfig: router,
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('hu', 'HU'),
                ],
                locale: const Locale('hu', 'HU'),
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  LocalJsonLocalization.delegate,
                ],
              );
            });
      },
      maximumSize: const Size(500, 1000),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  UserModel? user = ref.watch(userDataProvider);
  if (user == null) {
    Future(() => ref.read(loginDataProvider.notifier).loginWithSavedData());
  }
  return GoRouter(
      navigatorKey: GlobalKey<NavigatorState>(),
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => const HomePage(),
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) => const HomePage(),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            var map = state.extra == null ? null : state.extra as Map<String, dynamic>;
            return LoginPage(origRoute: map == null ? "" : map["origRoute"] ?? "/");
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
        ),
        GoRoute(path: '/admin', builder: (BuildContext context, GoRouterState state) => const AdminPage(), routes: [
          GoRoute(path: "activities", builder: (BuildContext context, GoRouterState state) => const ActivitiesPage()),
          GoRoute(
              path: "createTransaction",
              builder: (BuildContext context, GoRouterState state) {
                var map = state.extra as Map<String, dynamic>;
                return CreateTransactionPage(
                  transactionType: map["transactionType"] ?? TransactionType.CREDIT,
                  account: map["account"] ?? Account.MYSHARE,
                );
              }),
          GoRoute(path: "userStatus", builder: (BuildContext context, GoRouterState state) => const UserStatusPage()),
          GoRoute(path: "users", builder: (BuildContext context, GoRouterState state) => const UsersPage()),
          GoRoute(path: "goals", builder: (BuildContext context, GoRouterState state) => const GoalPage()),
          GoRoute(
              path: "mentorMentees", builder: (BuildContext context, GoRouterState state) => const MentorMenteesPage()),
          GoRoute(
              path: "transactions", builder: (BuildContext context, GoRouterState state) => const TransactionsPage()),
        ]),
        GoRoute(
          path: '/users',
          builder: (BuildContext context, GoRouterState state) => const UsersPage(),
        ),
        GoRoute(
          path: '/userPoints',
          builder: (BuildContext context, GoRouterState state) => const UserPointsPage(),
        ),
        GoRoute(
          path: '/changePassword',
          builder: (BuildContext context, GoRouterState state) => const ChangePasswordPage(),
        ),
        GoRoute(
          path: '/createActivity',
          builder: (BuildContext context, GoRouterState state) => const CreateActivityPage(),
        ),
        GoRoute(
          path: '/transactionItems',
          builder: (BuildContext context, GoRouterState state) {
            var map = state.extra as Map<String, dynamic>;
            return TransactionItemsPage(transaction: map["transaction"] ?? 0);
          },
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
      redirect: (BuildContext context, GoRouterState state) {
        if (user == null) {
          if (([...userScreens, ...teamLeaderScreens].contains(state.matchedLocation) ||
              state.matchedLocation.contains("/admin/"))) {
            return "/login?origRoute=${state.matchedLocation}";
          } else {
            return null;
          }
        }

        if (teamLeaderScreens.contains(state.matchedLocation) && user.isTeamLeader()) {
          return null;
        }

        if (state.matchedLocation.contains("/admin/") && !user.isAdmin()) {
          return "/home";
        }

        return null;
      });
});

List<String> teamLeaderScreens = ["/admin", "/admin/userStatus"];

List<String> userScreens = ["/profile", "/createActivity", "/userPoints", "/mentees", "/activities"];
