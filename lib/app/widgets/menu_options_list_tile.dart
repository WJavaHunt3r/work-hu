import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuOptionsListTile extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool enabled;

  const MenuOptionsListTile({super.key, required this.title, required this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.sp),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
        tileColor: enabled ? Colors.white : Colors.grey.shade200,
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: enabled ? onTap : null,
      ),
    );
  }
}
