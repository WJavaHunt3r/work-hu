import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollapsablePanel extends StatelessWidget {
  const CollapsablePanel({super.key, required this.expansionCallback, required this.panels});

  final Function(int, bool) expansionCallback;
  final List<ExpansionPanel> panels;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionPanelList(
        materialGapSize: 0.sp,
        expansionCallback: expansionCallback,
        elevation: 0,
        dividerColor: Colors.white,
        children: panels,
      ),
    ));
  }
}
