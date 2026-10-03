import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_confirm_dialog.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';

import 'list_query.dart';
import 'paged_list_notifier.dart';
import 'paged_state.dart';

/// Page for a [PagedListNotifier]: infinite scroll, pull to refresh, sort menu, inline retry and swipe to delete.
///
/// Subclasses provide [provider] and [buildListTile]; filters go in [buildFilterLayout] and call
/// `notifier.setFilter(...)`.
abstract class PagedListPageState<P extends BaseListPage, T, F, N extends PagedListNotifier<T, F>>
    extends BasePageState<P, PagedState<T, F>, N> {
  /// Start loading the next page when less than this many viewport heights are left below.
  static const double _prefetchViewports = 1.5;

  N get notifier => ref.read(provider.notifier);

  List<T> get items => state.items;

  @override
  BaseState get status => state.baseStatus;

  Widget buildListTile(T item, int index);

  List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) => [];

  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) => [];

  /// Replaces the default list of [buildListTile]s when not null.
  Widget? buildListLayout(BuildContext context, WidgetRef ref) => null;

  bool canDelete(T item) => false;

  void onDelete(T item) {}

  @override
  void onRefresh() => notifier.reload();

  @override
  void onScroll() => _scheduleLoadCheck(prefetch: true);

  bool _loadCheckScheduled = false;
  bool _prefetchScheduled = false;

  /// Checks for the next page after the coming frame's layout. Checking right away could see a page that just
  /// arrived without its height, and load another one.
  ///
  /// With [prefetch] (scrolling), loads ahead once the end is near. Without (after a build), loads only when the
  /// list doesn't reach the bottom of the screen, since no scroll event would ever ask for more.
  void _scheduleLoadCheck({required bool prefetch}) {
    _prefetchScheduled |= prefetch;
    if (_loadCheckScheduled) return;
    _loadCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefetch = _prefetchScheduled;
      _loadCheckScheduled = false;
      _prefetchScheduled = false;
      _maybeLoadNextPage(prefetch: prefetch);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _maybeLoadNextPage({required bool prefetch}) {
    // After a failed page, wait for the user to tap retry instead of re-requesting on every scroll event.
    if (!mounted || !state.hasMore || status.modelState.isBackgroundError) return;

    final controller = getController();
    if (!controller.hasClients) return;
    final pos = controller.position;

    final threshold = prefetch ? pos.viewportDimension * _prefetchViewports : 0.0;
    if (pos.extentAfter <= threshold) {
      notifier.loadMore();
    }
  }

  /// Headers, filters, sort and the reload indicator stay pinned above the scrolling list.
  @override
  Widget buildPinnedHeader() {
    final isReloading = status.modelState.isBackgroundLoading && state.requestedPage == 0 && items.isNotEmpty;
    final sortOptions = notifier.sortOptions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HeaderChipLayout(buildChildren: (headerContext) => buildHeaderLayout(headerContext, ref)),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(spacing: 8.sp, runSpacing: 4.sp, children: buildFilterLayout(context, ref)),
              ),
            ),
            if (sortOptions.isNotEmpty)
              PagedSortButton(options: sortOptions, current: state.query.sort, onSelected: notifier.setSort),
            Text("${items.length}/${state.totalElements}", style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        // Fixed height so the list doesn't jump when the reload indicator appears.
        SizedBox(
          height: 8.sp,
          child: isReloading ? Center(child: LinearProgressIndicator(minHeight: 2.sp)) : null,
        ),
      ],
    );
  }

  @override
  Widget buildLayout() {
    // Covers a page that doesn't fill the screen, where no scroll event would ever fire.
    _scheduleLoadCheck(prefetch: false);

    final modelState = status.modelState;
    final isLoadingMore = modelState.isBackgroundLoading && state.requestedPage > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (items.isEmpty && modelState.isAnyLoading)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32.sp),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (items.isEmpty && modelState.isBackgroundError)
          _buildRetry()
        else if (items.isEmpty)
          Center(
            child: Text(
              "base_no_items_found".i18n(),
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          )
        else ...[
          buildListLayout(context, ref) ??
              BaseListView(
                hasBottomPadding: !isLoadingMore && !modelState.isBackgroundError,
                physics: const NeverScrollableScrollPhysics(),
                children: [for (var i = 0; i < items.length; i++) _buildSlidable(items[i], i)],
              ),
          if (isLoadingMore)
            Padding(
              padding: EdgeInsets.only(top: 16.sp, bottom: 80.sp),
              child: Center(
                child: SizedBox(
                  width: 24.sp,
                  height: 24.sp,
                  child: CircularProgressIndicator(strokeWidth: 2.sp),
                ),
              ),
            ),
          if (modelState.isBackgroundError) _buildRetry(),
        ],
      ],
    );
  }

  /// The default tiles, with swipe to delete, for part of [items]; for a custom [buildListLayout].
  List<Widget> buildListTiles(Iterable<T> subset) => [
    for (final item in subset) _buildSlidable(item, items.indexOf(item)),
  ];

  Widget _buildSlidable(T item, int index) {
    return Slidable(
      enabled: canDelete(item),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _deleteConfirmation(item),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'base_delete'.i18n(),
          ),
        ],
      ),
      child: buildListTile(item, index),
    );
  }

  Widget _buildRetry() {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 16.sp, bottom: 80.sp),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("api_unknown_error".i18n(), style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
            SizedBox(height: 8.sp),
            TextButton.icon(onPressed: notifier.retry, icon: const Icon(Icons.refresh), label: Text("retry".i18n())),
          ],
        ),
      ),
    );
  }

  void _deleteConfirmation(T item) {
    showDialog(
      context: context,
      builder: (context) => BaseConfirmDialog(
        title: "base_delete".i18n(),
        content: "base_delete_question",
        onConfirm: () => onDelete(item),
      ),
    );
  }
}

/// Sort menu listing every [SortOption] ascending and descending, with a check on [current].
class PagedSortButton extends StatelessWidget {
  const PagedSortButton({super.key, required this.options, required this.current, required this.onSelected});

  final List<SortOption> options;
  final List<SortOrder> current;
  final void Function(List<SortOrder>) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<List<SortOrder>>(
      icon: const Icon(Icons.filter_list),
      onSelected: onSelected,
      color: Theme.of(context).colorScheme.primary,
      offset: const Offset(0, 50),
      itemBuilder: (context) => [
        for (final option in options)
          for (final dir in SortDir.values)
            PopupMenuItem<List<SortOrder>>(
              value: option.orders(dir),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${option.label.i18n()} ${"base_filter_${dir.name}".i18n()}",
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_matches(option.orders(dir))) const Icon(Icons.check, color: Colors.white),
                ],
              ),
            ),
      ],
    );
  }

  bool _matches(List<SortOrder> orders) =>
      orders.length == current.length && Iterable.generate(orders.length).every((i) => orders[i] == current[i]);
}
