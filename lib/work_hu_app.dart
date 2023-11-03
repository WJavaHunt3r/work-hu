import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/style/app_style.dart';
import 'package:work_hu/features/admin/view/admin_page.dart';
import 'package:work_hu/features/change_password/view/change_password_page.dart';
import 'package:work_hu/features/home/view/home_page.dart';
import 'package:work_hu/features/login/view/login_page.dart';
import 'package:work_hu/features/transaction_items/view/transaction_items_page.dart';
import 'package:work_hu/features/user_points/view/user_points_page.dart';
import 'package:work_hu/features/users/view/users_page.dart';

import 'features/profile/view/profile_page.dart';

class WorkHuApp extends ConsumerWidget {
  const WorkHuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterWebFrame(
      builder: (context) {
        return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            ensureScreenSize: true,
            useInheritedMediaQuery: true,
            splitScreenMode: false,
            builder: (context, child) {
              final theme = GlobalTheme();
              final router = ref.watch(routerProvider);
              return MaterialApp.router(
                scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
                debugShowCheckedModeBanner: false,
                title: 'WORK HU',
                theme: theme.globalTheme,
                routerConfig: router,
                // routeInformationParser: router.routeInformationParser,
                // routeInformationProvider: router.routeInformationProvider,
                // routerDelegate: router.routerDelegate,
              );
            });
      },
      maximumSize: const Size(475.0, 812.0),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
      navigatorKey: GlobalKey<NavigatorState>(),
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => const HomePage(),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) => const LoginPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
        ),
        GoRoute(
          path: '/admin',
          builder: (BuildContext context, GoRouterState state) => const AdminPage(),
        ),
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
          path: '/transactionItems',
          builder: (BuildContext context, GoRouterState state) {
            var map = state.extra as Map<String, dynamic>;
            return TransactionItemsPage(transactionId: map["transactionId"] ?? 0);
          },
        ),
      ],
    ));
