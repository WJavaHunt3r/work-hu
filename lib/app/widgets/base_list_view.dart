import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseListView extends StatelessWidget {
  const BaseListView(
      {super.key,
      required this.itemBuilder,
      required this.itemCount,
      required this.children,
      this.shadowColor,
      this.cardBackgroundColor,
      this.physics,
      this.shrinkWrap});

  final Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final List<Widget> children;
  final Color? shadowColor;
  final Color? cardBackgroundColor;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView(physics: physics, shrinkWrap: shrinkWrap ?? false, children: [
      itemCount != 0
          ? Card(
              shadowColor: shadowColor,
              color: cardBackgroundColor,
              margin: EdgeInsets.symmetric(vertical: 8.sp),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
              child: ListView.builder(
                  padding: EdgeInsets.all(0.sp),
                  itemCount: itemCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => itemBuilder(context, index)),
            )
          : const SizedBox(),
      ...children
    ]);
  }
}
