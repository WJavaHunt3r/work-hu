import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base_page.dart';

/// Page widget for a list screen; its state extends `PagedListPageState`.
abstract class BaseListPage extends BasePage {
  const BaseListPage({
    super.key,
    required super.title,
    super.hasAppBar = true,
    super.hasHeadData = false,
    super.canPop = true,
    super.titleArgs,
  }) : super();
}

class HeaderChipLayout extends StatelessWidget {
  final List<Widget> Function(BuildContext) buildChildren;

  const HeaderChipLayout({super.key, required this.buildChildren});

  @override
  Widget build(BuildContext context) {
    var widgets = buildChildren(context);
    return widgets.isEmpty
        ? const SizedBox()
        : Wrap(
            spacing: 4.sp,
            runSpacing: 12.sp,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.start,
            children: [...widgets],
          );
  }
}
