import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/widgets/base_confirm_dialog.dart';
import 'package:work_hu/features/utils.dart';

import '../../../models/mode_state.dart';

abstract class BasePage extends ConsumerStatefulWidget {
  const BasePage({
    super.key,
    required this.title,
    this.hasHeadData = false,
    this.canPop = true,
    this.leading,
    this.hasAppBar = true,
    this.canRefresh = true,
    this.titleArgs = const [],
  });

  final Object title;

  /// Arguments for a [title] i18n key with placeholders.
  final List<String> titleArgs;
  final bool hasHeadData;
  final bool canPop;
  final Widget? leading;
  final bool hasAppBar;
  final bool canRefresh;
}

abstract class BasePageState<P extends BasePage, S extends dynamic, N extends StateNotifier<S>>
    extends ConsumerState<P> {
  late final ScrollController _scrollController;

  /// Set while the current error has been shown, so later state changes don't reopen the dialog.
  bool _errorShown = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      postInit(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    // The loading overlay is driven by BaseDataNotifier.executeApiCall; showing it here as well
    // unbalanced LoadingScreen's show/hide counter.
    ref.listen(provider, (previous, next) {
      if (!status.modelState.isError) {
        _errorShown = false;
      } else if (!_errorShown) {
        _errorShown = true;
        Utils.showErrorDialog(context, content: status.message.i18n());
      }
    });
    final pinnedHeader = buildPinnedHeader();
    return PopScope(
      canPop: widget.canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        confirmExit();
      },
      child: Scaffold(
        extendBodyBehindAppBar: !widget.hasAppBar,
        resizeToAvoidBottomInset: true,
        persistentFooterButtons: buildPersistentFooterButtons(context, ref),
        persistentFooterDecoration: const BoxDecoration(),
        persistentFooterAlignment: AlignmentDirectional.bottomCenter,
        bottomNavigationBar: buildBottomNavigationBar(context, ref),
        floatingActionButton: buildFloatingActionButton(context, ref),
        appBar: !widget.hasAppBar
            ? null
            : AppBar(
                automaticallyImplyLeading: true,
                title: (widget.title is Widget
                    ? widget.title as Widget
                    : InkWell(
                        onTap: () => onRefresh(),
                        child: Text(
                          ((widget.title) as String).i18n(widget.titleArgs),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      )),
                leadingWidth: widget.leading == null ? null : 80.sp,
                leading: widget.leading,
                actions: buildActions(context, ref),
                actionsPadding: EdgeInsets.symmetric(horizontal: 12.sp),
              ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pinnedHeader != null)
              Padding(
                padding: EdgeInsets.only(left: 16.sp, right: 16.sp, top: 16.sp),
                child: pinnedHeader,
              ),
            Expanded(
              child: widget.canRefresh
                  ? RefreshIndicator(
                      onRefresh: () async {
                        onRefresh();
                      },
                      child: _buildScrollView(hasPinnedHeader: pinnedHeader != null),
                    )
                  : _buildScrollView(hasPinnedHeader: pinnedHeader != null),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollView({required bool hasPinnedHeader}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          onScroll();
        }
        return false;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Padding(
          padding: EdgeInsets.only(left: 16.sp, right: 16.sp, top: hasPinnedHeader ? 0 : 16.sp, bottom: 16.sp),
          child: buildLayout(),
        ),
      ),
    );
  }

  void postInit(WidgetRef ref) {}

  StateNotifierProvider<N, S> get provider;

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
            dialogContext.pop();
          },
        );
      },
    );
  }

  Widget buildLayout();

  /// Shown above the scroll view, so it stays visible while [buildLayout] scrolls.
  Widget? buildPinnedHeader() => null;

  List<Widget>? buildActions(BuildContext context, WidgetRef ref) {
    return [];
  }

  void onRefresh() {}

  ScrollController getController() {
    return _scrollController;
  }

  void onScroll() {}
}
