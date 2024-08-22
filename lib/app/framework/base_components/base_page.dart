import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/title_provider.dart';

abstract class BasePage extends ConsumerWidget {
  const BasePage(
      {super.key,
      required this.title,
      this.automaticallyImplyLeading,
      this.canPop = true,
      this.isListView = false,
      this.appBarTextStyle,
      this.centerTitle,
      this.extendBodyBehindAppBar});

  final String title;
  final bool? automaticallyImplyLeading;
  final bool canPop;
  final bool isListView;
  final TextStyle? appBarTextStyle;
  final bool? centerTitle;
  final bool? extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
        canPop: canPop,
        onPopInvoked: (didPop) => popInvoked(context, didPop, ref),
        child: Scaffold(
            drawer: buildDrawer(context, ref),
            bottomNavigationBar: buildBottomNavigationBar(context, ref),
            extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
            appBar: extendBodyBehindAppBar ?? false
                ? null
                : AppBar(
                    backgroundColor: Colors.transparent,
                    title: Text(
                      title.isEmpty ? ref.watch(titleDataProvider) : title.i18n(),
                      style: appBarTextStyle ?? const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    centerTitle: centerTitle ?? false,
                    actions: buildActions(context, ref),
                    automaticallyImplyLeading: automaticallyImplyLeading ?? true,
                  ),
            floatingActionButton: createActionButton(context, ref),
            resizeToAvoidBottomInset: false,
            body: buildBody(context, ref) ??
                SizedBox.expand(
                  child: Container(
                      padding: EdgeInsets.only(left: 8.sp, right: 8.sp, top: isListView ? 0 : 8.sp, bottom: 0.sp),
                      child: buildLayout(context, ref)),
                )));
  }

  Widget buildLayout(BuildContext context, WidgetRef ref);

  @protected
  Widget? buildBody(BuildContext context, WidgetRef ref) {
    return null;
  }

  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    return [];
  }

  popInvoked(BuildContext context, bool didPop, WidgetRef ref) {}

  NavigationDrawer? buildDrawer(BuildContext context, WidgetRef ref) {
    return null;
  }

  Widget? createActionButton(BuildContext context, WidgetRef ref) {
    return null;
  }

  buildBottomNavigationBar(BuildContext context, WidgetRef ref) {}
}
