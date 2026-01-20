import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/features/home/providers/home_provider.dart';

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
              onTap: () => ref.read(homeDataProvider.notifier).getTeamRounds(),
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
