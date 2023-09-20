import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/style/app_style.dart';

import 'features/hours/widgets/hours.dart';
import 'features/status/widgets/status.dart';

class WorkHuApp extends StatelessWidget {
  WorkHuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: false,
      builder: (context, child) {
        final theme = GlobalTheme();
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'WORK HU',
          theme: theme.globalTheme,
          routeInformationParser: _router.routeInformationParser,
          routeInformationProvider: _router.routeInformationProvider,
          routerDelegate: _router.routerDelegate,
        );
      },
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const Home(),
      ),
      GoRoute(
        path: '/status',
        builder: (BuildContext context, GoRouterState state) => const Status(),
      ),
      GoRoute(
        path: '/points',
        builder: (BuildContext context, GoRouterState state) => const Hours(),
      ),

    ],
  );
}

final counterProvider = StateProvider((ref) => 0);

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('WORK HU')),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/WORK_Bakgrunn_03_cut.jpg"),
            opacity: 0.6,
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer(
          builder: (context, ref, _) {
            final count = ref.watch(counterProvider);
            return _pages.elementAt(count);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        selectedItemColor: AppColors.appGreen,
        selectedFontSize: 12.sp,
        unselectedIconTheme: const IconThemeData(opacity: 0.0),
        items: [
          BottomNavigationBarItem(
              icon: Image(
                image: const AssetImage("assets/logos/Work_black_white.png"),
                fit: BoxFit.contain,
                height: 25.sp,
              ),
              label: "Status"),
          BottomNavigationBarItem(
            icon: Image(
              image: const AssetImage("assets/icons/profit.png"),
              fit: BoxFit.contain,
              height: 25.sp,
            ),
            label: "Points",
          ),
        ],
        currentIndex: ref.watch(counterProvider),
        onTap: (i) => ref.read(counterProvider.notifier).state = i,
      ),
    );
  }

  static const List<Widget> _pages = <Widget>[Status(), Hours()];


}
