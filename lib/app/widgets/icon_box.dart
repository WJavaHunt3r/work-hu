import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconBox extends StatelessWidget {
  final IconData icon;

  const IconBox({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(25),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary),
    );
  }
}
