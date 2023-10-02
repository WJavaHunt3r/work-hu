import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';

class AdminCard extends StatelessWidget {
  const AdminCard({super.key, required this.onTap, required this.imageAsset, this.backgroundColor});

  final Function() onTap;
  final String imageAsset;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: InkResponse(
                onTap: onTap,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                      color: backgroundColor ?? AppColors.primary,
                      height: 80.sp,
                      child: Padding(
                        padding: EdgeInsets.all(4.sp),
                        child: Image(image: AssetImage(imageAsset), fit: BoxFit.fitWidth, height: 100.sp),
                      )),
                )))
      ],
    );
  }
}
