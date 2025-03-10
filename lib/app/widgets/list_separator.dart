import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/app_colors.dart';

class ListSeparator extends StatelessWidget {
  const ListSeparator({super.key, this.padding, this.height});

  final double? padding;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 2.sp),
      child: Container(
        height: height ?? 1.5.sp,
        color: AppColors.gray100,
      ),
    );
  }
}
