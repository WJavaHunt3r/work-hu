import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/features/login/view/login_layout.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SizedBox.expand(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(15.sp),
            child: LoginLayout(),
          ),
        ),
      ),
    );
  }
}
