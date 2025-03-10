import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AccountBalance extends StatelessWidget {
  const AccountBalance({super.key, required this.name, required this.balance});

  final String name;
  final String balance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: 8.sp),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
            )),
        Padding(
            padding: EdgeInsets.only(bottom: 8.sp),
            child: Text(
              "${balance.replaceAll(".00", "")} Ft",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
            )),
        // Column(
        //   children: [
        //     IconButton(
        //         onPressed: () => context
        //                 .push(
        //                     "/payment/eyJjaGVja291dElkIjoiNTZmNzFhNmQtOTBjZi00YzZhLTg1NDMtZjZiMmFjZjQxMmJmIiwiZGVzY3JpcHRpb24iOiJUZXN0IHBheW1lbnQiLCJsb2NhbGUiOiJodS1IVSJ9")
        //                 .then((value) {
        //               if (value != null) {
        //                 showModalBottomSheet(
        //                     context: context,
        //                     builder: (context) {
        //                       return Text(value.toString());
        //                     });
        //               }
        //             }),
        //         icon: Icon(Icons.add)),
        //     Text("Feltöltés")
        //   ],
        // ),
      ],
    );
  }
}
