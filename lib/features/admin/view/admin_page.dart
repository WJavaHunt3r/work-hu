import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_service.dart';
import 'package:work_hu/features/admin/view/admin_layout.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    var user = locator<UserService>().currentUser;
    return Scaffold(
      // drawer: user != null && user.role != Role.USER
      //     ? Drawer(
      //         child: ListView(
      //           children: [
      //             DrawerHeader(
      //               child: Text(
      //                 'Admin',
      //                 style: TextStyle(fontSize: 18.sp),
      //               ),
      //             ),
      //             ListTile(
      //               title: const Text('Vær et forbilde'),
      //               selectedColor: AppColors.errorRed,
      //               onTap: () {
      //                 // Then close the drawer
      //                 Navigator.pop(context);
      //               },
      //             ),
      //             ListTile(
      //               title: const Text('MyShare transactions'),
      //               selectedColor: AppColors.errorRed,
      //               onTap: () {
      //                 // Then close the drawer
      //                 Navigator.pop(context);
      //               },
      //             ),
      //             ListTile(
      //               title: const Text('Samvirk transactions'),
      //               selectedColor: AppColors.errorRed,
      //               selected: true,
      //               onTap: () {
      //                 // Then close the drawer
      //                 Navigator.pop(context);
      //               },
      //             ),
      //             ListTile(
      //               title: const Text('Other Point transactions'),
      //               selectedColor: AppColors.errorRed,
      //               onTap: () {
      //                 // Then close the drawer
      //                 Navigator.pop(context);
      //               },
      //             ),
      //           ],
      //         ),
      //       )
      //     : null,
      appBar: AppBar(
        title: Text("Admin", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18.sp)),
      ),
      body: Padding(padding: EdgeInsets.all(12.sp), child: const AdminLayout()),
    );
  }
}
