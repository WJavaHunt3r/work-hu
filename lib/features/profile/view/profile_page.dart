import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/features/profile/view/profile_layout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.w800),),
        actions: [IconButton(onPressed: () => context.push("/admin"), icon: const Icon(Icons.admin_panel_settings_outlined))],
      ),
      body: SizedBox.expand(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(12.sp),
            child: const ProfileLayout(),
          ),
        ),
      ),
    );
  }
}
