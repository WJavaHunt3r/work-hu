import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_service.dart';
import 'package:work_hu/features/home/providers/team_provider.dart';

import '../data/model/team_model.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(teamDataProvider);
    var user = locator<UserService>().currentUser;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Work HU",style: TextStyle(fontWeight: FontWeight.w800)),
          actions: user == null
              ? [
                  IconButton(
                      onPressed: () => context.push("/login").then((value) => ref.refresh(teamDataProvider)),
                      icon: const Icon(Icons.login))
                ]
              : [
                  IconButton(
                      onPressed: () => context.push("/profile").then((value) => ref.refresh(teamDataProvider)),
                      icon: const Icon(Icons.perm_identity_rounded))
                ],
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                  onRefresh: () async => ref.read(teamDataProvider.notifier).getTeams(),
                  child: ref.watch(teamDataProvider).isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ref.watch(teamDataProvider).isError
                          ? const ErrorView()
                          : StatusView(teams: ref.watch(teamDataProvider).teams)),
            )
          ],
        ));
  }
}

class ErrorView extends ConsumerWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.expand(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: InkResponse(
              onTap: () => ref.read(teamDataProvider.notifier).getTeams(),
              child: Image(
                image: const AssetImage("assets/img/server_error.jpg"),
                fit: BoxFit.contain,
                height: 100.sp,
              )),
        ),
        const Text("Server error")
      ],
    ));
  }
}

class StatusView extends StatelessWidget {
  const StatusView({super.key, required this.teams});

  final List<TeamModel> teams;

  @override
  Widget build(BuildContext context) {
    var max = 0.0;
    for (var t in teams) {
      if (t.points > max) max = t.points;
    }
    return Column(
      children: [
        Expanded(
          child: SizedBox(
              child: Padding(
                  padding: EdgeInsets.all(0.sp),
                  child: ListView.builder(
                      itemCount: teams.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return StatusRow(
                          logoColor: teams[index].color,
                          value: teams[index].points,
                          maximum: (max / 50) + 50,
                        );
                      }))),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: Center(
              child: Text(
                "Last updated: 2023.09.15.",
                style: TextStyle(fontSize: 15.sp),
              ),
            )),
      ],
    );
  }
}

class StatusRow extends StatelessWidget {
  StatusRow({super.key, required this.logoColor, required this.value, required this.maximum});

  final String logoColor;
  final double value;
  final double maximum;
  final NumberFormat numberFormat = NumberFormat("###.#");

  @override
  Widget build(BuildContext context) {
    final Color color = logoColor == "BLUE"
        ? AppColors.teamBlue
        : logoColor == "GREEN"
            ? AppColors.teamGreen
            : logoColor == "RED"
                ? AppColors.teamRed
                : AppColors.teamOrange;
    return SizedBox(
        height: 80.sp,
        child: Padding(
            padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
            child: Row(
              children: [
                Image(
                  image: AssetImage("assets/logos/WORK_${logoColor}_black_Vácduka.png"),
                  fit: BoxFit.contain,
                  height: 60.sp,
                ),
                SizedBox(
                  width: 10.sp,
                ),
                Expanded(
                    child: SfLinearGauge(
                        orientation: LinearGaugeOrientation.horizontal,
                        axisTrackStyle: LinearAxisTrackStyle(
                            thickness: 50.sp, color: Colors.transparent, edgeStyle: LinearEdgeStyle.bothCurve),
                        minimum: 0,
                        maximum: maximum,
                        showLabels: false,
                        showTicks: false,
                        markerPointers: null,
                        barPointers: [
                      LinearBarPointer(
                        thickness: 30.sp,
                        color: color,
                        edgeStyle: LinearEdgeStyle.endCurve,
                        value: value,
                      )
                    ])),
                SizedBox(
                    width: 65.sp,
                    child: Text(
                      numberFormat.format(value),
                      style: TextStyle(color: color, fontSize: 25.sp, fontWeight: FontWeight.w800),
                    ))
              ],
            )));
  }
}
