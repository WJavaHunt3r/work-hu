import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/title_provider.dart';
import 'package:work_hu/app/widgets/base_confirm_dialog.dart';
import 'package:work_hu/app/widgets/base_search_bar.dart';
import 'package:work_hu/app/widgets/loading_screen.dart';
import 'package:work_hu/features/utils.dart';

import '../../../models/mode_state.dart';

abstract class BasePage extends ConsumerStatefulWidget {
  const BasePage(
      {super.key, required this.title, this.hasHeadData = false, this.canPop = false, this.leading, this.hasAppBar = false});

  final Object title;
  final bool hasHeadData;
  final bool canPop;
  final Widget? leading;
  final bool hasAppBar;
}

abstract class BasePageState<P extends BasePage, S extends dynamic, N extends StateNotifier<S>> extends ConsumerState<P> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      postInit(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(provider, (previous, next) {
      if (status.modelState.isLoading) {
        LoadingScreen.instance().show(context: context);
      } else {
        LoadingScreen.instance().hide();
      }
      if (status.modelState.isError) {
        Utils.showErrorDialog(
          context,
          content: status.message,
        );
      }
    });
    return PopScope(
      canPop: widget.canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        confirmExit();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        persistentFooterButtons: buildPersistentFooterButtons(context, ref),
        persistentFooterDecoration: BoxDecoration(),
        persistentFooterAlignment: AlignmentDirectional.bottomCenter,
        bottomNavigationBar: buildBottomNavigationBar(context, ref),
        floatingActionButton: buildFloatingActionButton(context, ref),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: (widget.title is Widget
              ? widget.title as Widget
              : Text(((widget.title) as String).i18n(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
          leadingWidth: 80,
          leading: widget.leading,
          actions: buildActions(context, ref),
          actionsPadding: EdgeInsets.symmetric(horizontal: 4),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [Expanded(child: SingleChildScrollView(child: buildLayout()))],
          ),
        ),
      ),
    );
  }

  void postInit(WidgetRef ref) {}

  AutoDisposeStateNotifierProvider<N, S> get provider;

  BaseState get status;

  S get state => ref.watch(provider);

  void onSearch(BuildContext context) {}

  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return null;
  }

  List<Widget>? buildPersistentFooterButtons(BuildContext context, WidgetRef ref) {
    return null;
  }

  Widget? buildBottomNavigationBar(BuildContext context, WidgetRef ref) {
    return null;
  }

  void confirmExit() {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return BaseConfirmDialog(
          title: "base_exit",
          content: "base_exit_question",
          onConfirm: () {
            Navigator.of(dialogContext).pop(true);
          },
        );
      },
    );
  }

  Widget buildLayout();

  List<Widget>? buildActions(BuildContext context, WidgetRef ref) {
    return [];
  }
}

abstract class LegacyBasePage extends ConsumerWidget {
  const LegacyBasePage(
      {super.key,
      required this.title,
      this.automaticallyImplyLeading,
      this.canPop = true,
      this.isListView = false,
      this.appBarTextStyle,
      this.centerTitle,
      this.extendBodyBehindAppBar,
      this.leading,
      this.hasTitleWidget,
      this.hasSearchBar = false,
      this.titleArgs = const [],
      this.backgroundColor});

  final String title;
  final bool? automaticallyImplyLeading;
  final bool canPop;
  final bool isListView;
  final TextStyle? appBarTextStyle;
  final bool? centerTitle;
  final bool? extendBodyBehindAppBar;
  final List<String> titleArgs;
  final Widget? leading;
  final bool hasSearchBar;
  final bool? hasTitleWidget;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
        canPop: canPop,
        onPopInvokedWithResult: (didPop, result) async => await popInvoked(context, didPop, ref),
        child: Scaffold(
            drawer: buildDrawer(context, ref),
            bottomNavigationBar: buildBottomNavigationBar(context, ref),
            extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
            appBar: extendBodyBehindAppBar ?? false
                ? null
                : AppBar(
                    bottom: buildBottom(ref, context),
                    title: hasTitleWidget ?? false
                        ? buildTitleWidget(ref)
                        : (hasSearchBar
                            ? buildSearchBar(ref)
                            : Text(
                                title.isEmpty ? ref.watch(titleDataProvider) : title.i18n(titleArgs),
                                style: appBarTextStyle ?? const TextStyle(fontWeight: FontWeight.w800),
                              )),
                    leading: leading,
                    centerTitle: centerTitle ?? false,
                    actions: buildActions(context, ref),
                    automaticallyImplyLeading: automaticallyImplyLeading ?? !hasSearchBar,
                  ),
            floatingActionButton: createActionButton(context, ref),
            floatingActionButtonLocation: setFloatingActionButtonLocation(ref),
            resizeToAvoidBottomInset: false,
            body: buildBody(context, ref) ??
                SizedBox.expand(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 12.sp,
                          right: 12.sp,
                          top: isListView || hasSearchBar
                              ? 0
                              : extendBodyBehindAppBar ?? false
                                  ? 0.sp
                                  : 8.sp,
                          bottom: 0.sp),
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

  @protected
  FloatingActionButtonLocation setFloatingActionButtonLocation(WidgetRef ref) {
    return FloatingActionButtonLocation.centerFloat;
  }

  popInvoked(BuildContext context, bool didPop, WidgetRef ref) {}

  NavigationDrawer? buildDrawer(BuildContext context, WidgetRef ref) {
    return null;
  }

  Widget? createActionButton(BuildContext context, WidgetRef ref) {
    return null;
  }

  buildBottomNavigationBar(BuildContext context, WidgetRef ref) {}

  Widget buildSearchBar(WidgetRef ref) {
    return SizedBox(height: 35.sp, child: BaseSearchBar(onChanged: (text) => searchBarChanged(ref, text)));
  }

  searchBarChanged(WidgetRef ref, String text) {}

  Widget buildTitleWidget(WidgetRef ref) {
    return const SizedBox();
  }

  PreferredSizeWidget? buildBottom(WidgetRef ref, BuildContext context) {
    return null;
  }
}
