import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/style/app_style.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/activities/view/activities_page.dart';
import 'package:work_hu/features/activity_items/view/activity_items_layout.dart';
import 'package:work_hu/features/admin/view/admin_page.dart';
import 'package:work_hu/features/change_password/view/change_password_page.dart';
import 'package:work_hu/features/create_activity/view/create_activity_page.dart';
import 'package:work_hu/features/create_transactions/view/create_transaction_page.dart';
import 'package:work_hu/features/fra_kare_week/view/fra_kare_week_page.dart';
import 'package:work_hu/features/goal/view/goal_page.dart';
import 'package:work_hu/features/home/view/home_page.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/login/view/login_page.dart';
import 'package:work_hu/features/mentees/view/mentees_page.dart';
import 'package:work_hu/features/mentor_mentee/view/mentor_mentees_page.dart';
import 'package:work_hu/features/transaction_items/view/transaction_items_page.dart';
import 'package:work_hu/features/transactions/view/transactions_page.dart';
import 'package:work_hu/features/user_fra_kare_week/view/user_fra_kare_week_page.dart';
import 'package:work_hu/features/user_points/view/user_points_page.dart';
import 'package:work_hu/features/user_status/view/user_status_page.dart';
import 'package:work_hu/features/users/view/users_page.dart';
import 'features/create_transactions/view/create_samvirk_transactions_page.dart';
import 'features/profile/view/profile_page.dart';

class DukApp extends ConsumerWidget {
  DukApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.sizeOf(context).width;
    return FlutterWebFrame(
        backgroundColor: AppColors.backgroundColor,
        builder: (context) {
          return ScreenUtilInit(
              designSize: const Size(360, 640),
              minTextAdapt: true,
              ensureScreenSize: true,
              enableScaleText: () => true,
              enableScaleWH: () => width > 500 ? false : true,
              splitScreenMode: false,
              builder: (context, child) {
                LocalJsonLocalization.delegate.directories = ['lib/I18n'];
                return Center(
                    child: ClipRect(
                        child: SizedBox(
                  width: 500,
                  child: buildMaterial(ref),
                )));
              });
        },
        maximumSize: const Size(500, 1000));
  }

  buildMaterial(WidgetRef ref) {
    final theme = GlobalTheme();
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
      debugShowCheckedModeBanner: false,
      title: 'DukApp',
      theme: theme.globalTheme,
      routerConfig: router,
      supportedLocales: const [
        const Locale('en', 'US'),
        const Locale('hu', 'HU'),
      ],
      locale: const Locale('hu', 'HU'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      navigatorKey: GlobalKey<NavigatorState>(),
      initialLocation: "/",
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => HomePage(),
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) => HomePage(),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            var map = state.extra == null ? null : state.extra as Map<String, dynamic>;
            return LoginPage(origRoute: map == null ? "" : map["origRoute"] ?? "/");
          },
        ),
        GoRoute(path: '/profile', builder: (BuildContext context, GoRouterState state) => ProfilePage(), routes: [
          GoRoute(
            path: 'userPoints',
            builder: (BuildContext context, GoRouterState state) => UserPointsPage(),
          ),
        ]),
        GoRoute(path: '/admin', builder: (BuildContext context, GoRouterState state) => AdminPage(), routes: [
          GoRoute(path: "activities", builder: (BuildContext context, GoRouterState state) => ActivitiesPage()),
          GoRoute(
              path: "createTransaction",
              builder: (BuildContext context, GoRouterState state) => CreateTransactionPage()),
          GoRoute(
              path: "fraKareWeeks",
              builder: (BuildContext context, GoRouterState state) => FraKareWeekPage(),
              routes: [
                GoRoute(
                    path: ":id",
                    builder: (BuildContext context, GoRouterState state) =>
                        UserFraKareWeekPage(weekNumber: num.tryParse(state.pathParameters["id"] ?? "0") ?? 0))
              ]),
          GoRoute(
              path: "createSamvirkTransaction",
              builder: (BuildContext context, GoRouterState state) => CreateSamvirkTransactionPage()),
          GoRoute(path: "userStatus", builder: (BuildContext context, GoRouterState state) => UserStatusPage()),
          GoRoute(path: "users", builder: (BuildContext context, GoRouterState state) => UsersPage()),
          GoRoute(path: "goals", builder: (BuildContext context, GoRouterState state) => GoalPage()),
          GoRoute(path: "mentorMentees", builder: (BuildContext context, GoRouterState state) => MentorMenteesPage()),
          GoRoute(
              path: "transactions",
              builder: (BuildContext context, GoRouterState state) => TransactionsPage(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (BuildContext context, GoRouterState state) {
                    return TransactionItemsPage();
                  },
                ),
              ])
        ]),
        GoRoute(
            path: '/changePassword',
            builder: (BuildContext context, GoRouterState state) {
              return ChangePasswordPage();
            }),
        GoRoute(
          path: '/createActivity',
          builder: (BuildContext context, GoRouterState state) => CreateActivityPage(),
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
            return MenteesPage();
          },
        ),
        GoRoute(path: "/activities", builder: (BuildContext context, GoRouterState state) => ActivitiesPage())
      ],
      redirect: (BuildContext context, GoRouterState state) async {
        UserModel? user = ref.read(userDataProvider);
        user ??= await ref.read(loginDataProvider.notifier).loginWithSavedData();
        if (user == null) {
          if (([...userScreens, ...teamLeaderScreens].contains(state.matchedLocation) ||
              state.matchedLocation.contains("/admin/"))) {
            return "/login?origRoute=${state.matchedLocation}";
          } else {
            return null;
          }
        }

        if (teamLeaderScreens.contains(state.matchedLocation) && user.isTeamLeader()) {
          return state.matchedLocation;
        }

        if (state.matchedLocation.contains("/admin/") && !user.isAdmin()) {
          return "/home";
        }

        return state.matchedLocation;
      });
});

List<String> teamLeaderScreens = ["/admin", "/admin/userStatus"];

List<String> userScreens = ["/profile", "/createActivity", "/userPoints", "/mentees", "/activities"];
