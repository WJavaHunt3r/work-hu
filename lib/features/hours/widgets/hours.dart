import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Hours extends ConsumerWidget {
  const Hours({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
      image: AssetImage("assets/img/WORK_Bakgrunn_3D.jpg"),
      opacity: 0.6,
      fit: BoxFit.cover,
    )));
    // ListView.separated(
    //   itemBuilder: (BuildContext context, int index) {
    //     return HoursListItem(
    //       isMyshare: index % 2 == 0,
    //       value: index * 1000,
    //       date: DateTime.now(),
    //       title: "Just some text",
    //     );
    //   },
    //   separatorBuilder: (BuildContext context, int index) {
    //     return Padding(
    //         padding: EdgeInsets.only(left: 20.sp, right: 20.sp),
    //         child: Container(
    //           height: 1.2.sp,
    //           color: Colors.black,
    //         ));
    //   },
    //   itemCount: 10,
    // );
  }
}

class HoursListItem extends StatelessWidget {
  const HoursListItem(
      {required this.isMyshare, super.key, required this.value, required this.title, required this.date});

  final bool isMyshare;
  final num value;
  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
        child: SizedBox(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              )),
              SizedBox(
                  width: 80.sp,
                  child: Text(
                    "$value",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  )),
              Image(
                height: 30.sp,
                width: 30.sp,
                image: AssetImage(isMyshare ? "assets/img/myshare-logo.png" : "assets/img/Samvirk logo.png"),
                fit: BoxFit.scaleDown,
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                  width: 60.sp,
                  child: Text(
                      "${date.month < 10 ? "0${date.month}" : date.month}.${date.day < 10 ? "0${date.day}" : date.day}",
                      style: TextStyle(fontSize: 16.sp))),
            ],
          )
        ])));
  }
}
