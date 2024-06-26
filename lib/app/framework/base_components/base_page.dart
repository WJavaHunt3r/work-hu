import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/title_provider.dart';

abstract class BasePage extends ConsumerWidget {
  const BasePage(
      {super.key, required this.title, this.automaticallyImplyLeading, this.canPop = true, this.isListView = false});

  final String title;
  final bool? automaticallyImplyLeading;
  final bool canPop;
  final bool isListView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
        canPop: canPop,
        onPopInvoked: (didPop) => popInvoked(context, didPop, ref),
        child: Scaffold(
            drawer: buildDrawer(context, ref),
            appBar: AppBar(
              title: Text(
                title.isEmpty ? ref.watch(titleDataProvider) : title.i18n(),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              actions: buildActions(context, ref),
              automaticallyImplyLeading: automaticallyImplyLeading ?? true,
            ),
            floatingActionButton: createActionButton(context, ref),
            resizeToAvoidBottomInset: false,
            body: SizedBox.expand(
              child: Container(
                padding: EdgeInsets.only(left: 8.sp, right: 8.sp, top: isListView ? 0 : 8.sp, bottom: 0.sp),
                child: buildLayout(context, ref),
              ),
            )));
  }

  Widget buildLayout(BuildContext context, WidgetRef ref);

  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    return [];
  }

  popInvoked(BuildContext context, bool didPop, WidgetRef ref) {}

  Drawer? buildDrawer(BuildContext context, WidgetRef ref) {
    return null;
  }

  Widget? createActionButton(BuildContext context, WidgetRef ref) {
    return null;
  }
}
