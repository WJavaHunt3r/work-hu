import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_container.dart';

class LegacyBaseListView extends StatelessWidget {
  const LegacyBaseListView(
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
              shadowColor: Colors.transparent,
              color: Colors.transparent,
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

class BaseListView extends StatelessWidget {
  const BaseListView({
    super.key,
    required this.children,
    this.color,
    this.physics,
    this.hasBottomPadding = true,
    this.separated = true,
    this.isExpanded = false,
    this.scrollController,
    this.shrinkWrap = true
  });

  final List<Widget> children;
  final Color? color;
  final ScrollPhysics? physics;
  final bool hasBottomPadding;
  final bool separated;
  final bool isExpanded;
  final ScrollController? scrollController;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return children.isEmpty ? const SizedBox():Padding(
      padding: hasBottomPadding ? EdgeInsets.only(bottom: 75.sp) : EdgeInsets.zero,
      child: BaseContainer(
        color: color,
        padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 0.sp),
        child: isExpanded ? Expanded(child: buildListView()) : buildListView(),
      ),
    );
  }

  Widget buildListView() {
    return ListView.separated(
      controller: scrollController,
      itemCount: children.length,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        return children[index];
      },
      separatorBuilder: (BuildContext context, int index) {
        return separated ? Divider(height: 1.sp, color: Theme.of(context).colorScheme.surface) : const SizedBox(height: 0);
      },
    );
  }
}
