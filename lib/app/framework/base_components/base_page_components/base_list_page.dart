import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/widgets/base_confirm_dialog.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/base_sort_widget.dart';

import '../../../models/mode_state.dart';
import 'base_state.dart';
import 'list_api_provider.dart';

abstract class BaseListPage extends BasePage {
  const BaseListPage({
    super.key,
    required super.title,
    super.hasAppBar = true,
    super.hasHeadData = false,
    super.canPop = true,
  }) : super();

// final List<SortItem>? sortParameters;
}

abstract class BaseListPageState<P extends BaseListPage, S extends dynamic, N extends StateNotifier<S>>
    extends BasePageState<P, S, N> {
  // late BaseSearchBar? searchBar;

  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  bool _isLocalLoading = false;

  /// Page of the most recent [list] call; tells a reload (0) apart from loading more (> 0).
  int _requestedPage = 0;

  /// Start loading the next page when less than this many viewport heights are left below.
  static const double _prefetchViewports = 1.5;

  void updatePage(int nextPage) async {
    // Not every notifier awaits its API call, so also check the state flag, which
    // executeApiCall sets synchronously.
    if (_isLocalLoading || status.modelState.isAnyLoading) return;

    _isLocalLoading = true;

    try {
      await list(pageFrom: nextPage);
    } finally {
      _isLocalLoading = false;
    }
  }

  @override
  void onScroll() => _maybeLoadNextPage();

  void _maybeLoadNextPage() {
    // After a failed page, wait for the user to tap retry instead of re-requesting on every scroll event.
    if (!mounted || status.modelState.isAnyLoading || status.modelState.isBackgroundError) return;
    if (listStatus.totalPages <= listStatus.number + 1) return;

    final controller = getController();
    if (!controller.hasClients) return;
    final pos = controller.position;

    if (pos.extentAfter < pos.viewportDimension * _prefetchViewports) {
      updatePage(listStatus.number + 1);
    }
  }

  List<dynamic> buildListTiles(List<dynamic> listItems) {
    return listItems
        .map((e) => Slidable(
            enabled: canDelete(e),
            endActionPane: ActionPane(
              extentRatio: 0.3,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _deleteConfirmation(e),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_outline,
                  label: 'base_delete'.i18n(),
                ),
              ],
            ),
            child: buildListTile(e)))
        .toList();
  }

  @override
  Widget buildLayout() {
    // Also covers a first page that doesn't fill the screen, where no scroll event would ever fire.
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadNextPage());

    final modelState = listStatus.baseStatus.modelState;
    final isReloading = modelState.isBackgroundLoading && _requestedPage == 0 && items.isNotEmpty;
    final isLoadingMore = modelState.isBackgroundLoading && _requestedPage > 0;

    var headers = HeaderChipLayout(buildChildren: (filterContext) => buildHeaderLayout(filterContext, ref));
    var children = buildListTiles(items) as List<Widget>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        headers,
        FilterChipLayout(
          state: listStatus,
          buildChildren: (filterContext) => buildFilterLayout(filterContext, ref),
          filterValues: getFilters(),
          listLength: items.length,
          onSelected: (item) {
            var sort = SortBuilder();
            for (var s in item.values) {
              sort.add(s, descending: item.descending);
            }
            list(sort: sort.build());
          },
        ),
        // Fixed height so the list doesn't jump when the reload indicator appears.
        SizedBox(
          height: 8.sp,
          child: isReloading ? Center(child: LinearProgressIndicator(minHeight: 2.sp)) : null,
        ),
        if (items.isEmpty && modelState.isAnyLoading)
          Padding(padding: EdgeInsets.symmetric(vertical: 32.sp), child: const Center(child: CircularProgressIndicator()))
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
                  children: children),
          if (isLoadingMore)
            Padding(
              padding: EdgeInsets.only(top: 16.sp, bottom: 80.sp),
              child: Center(
                  child: SizedBox(
                      width: 24.sp, height: 24.sp, child: CircularProgressIndicator(strokeWidth: 2.sp))),
            ),
          if (modelState.isBackgroundError) _buildRetry(),
        ],
      ],
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
            TextButton.icon(
              onPressed: () => list(pageFrom: _requestedPage),
              icon: const Icon(Icons.refresh),
              label: Text("retry".i18n()),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(dynamic item) => ListTile(title: Text(item.toString()));

  List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) {
    return [];
  }

  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) {
    return [];
  }

  Widget? buildListLayout(BuildContext context, WidgetRef ref) => null;

  List get items;

  Future<void> list({dynamic filter, int? pageFrom = 0, List<String>? sort}) async {
    _requestedPage = pageFrom ?? 0;
    await (ref.read(provider.notifier) as ListApiProvider).list(filter: filter, page: pageFrom, sort: sort);
  }

  BaseListState get listStatus;

  @override
  BaseState get status => listStatus.baseStatus;

  List<dynamic> getFilters();

  void _deleteConfirmation(e) {
    showDialog(
        context: context,
        builder: (context) =>
            BaseConfirmDialog(title: "base_delete".i18n(), content: "base_delete_question", onConfirm: () => onDelete(e)));
  }

  onDelete(e) {}

  bool canDelete(item) => false;

  @override
  void onRefresh() {
    if (ref.read(provider.notifier) is ListApiProvider) {
      updatePage(0);
    }
  }
}

class FilterChipLayout extends StatelessWidget {
  final List<BaseFilterChip> Function(BuildContext) buildChildren;

  final Function(SortItem)? onSelected;

  final List<dynamic> filterValues;

  const FilterChipLayout(
      {super.key,
      required this.buildChildren,
      this.onSelected,
      required this.listLength,
      required this.filterValues,
      required this.state});

  final int listLength;
  final BaseListState state;

  @override
  Widget build(BuildContext context) {
    var widgets = buildChildren(context);
    // if (widgets.isEmpty) return const SizedBox();
    var text = "$listLength/${state.totalElements}";
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft, // Ensures the Wrap doesn't try to center stack
            child: Wrap(spacing: 8.sp, runSpacing: 4.sp, alignment: WrapAlignment.start, children: widgets),
          ),
        ),
        BaseSortWidget(sortParameters: state.sortParameters, onSelected: (value) => onSelected!(value)),
        Text(text.toString(), style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
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
            children: [...widgets]);
  }
}
