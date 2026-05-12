import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_container.dart';

class CollapsablePanel extends StatelessWidget {
  const CollapsablePanel({super.key, required this.expansionCallback, required this.panels});

  final Function(int, bool) expansionCallback;
  final List<ExpansionPanel> panels;

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      padding: EdgeInsets.all(8.sp),
        child: ExpansionPanelList(
          materialGapSize: 0.sp,
          expansionCallback: expansionCallback,
          elevation: 0,
          dividerColor: Colors.white,
          children: panels,
        ));
  }
}
