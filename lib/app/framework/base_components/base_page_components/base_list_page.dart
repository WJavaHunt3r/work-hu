import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_confirm_dialog.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/base_sort_widget.dart';

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
  late int _currentPage;

  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
  }

  void updatePage(int nextPage) {
    if (status.modelState.isLoading) return;

    setState(() {
      _currentPage = nextPage;
      list(pageFrom: _currentPage);
    });
  }

  @override
  void onScroll() {
    if (status.modelState.isLoading) return;

    final pos = getController().position;
    double maxScroll = pos.maxScrollExtent;
    double currentScroll = pos.pixels;

    if (currentScroll <= 0) return;

    double delta = 200.0;

    if (maxScroll - currentScroll <= delta) {
      if (listStatus.totalPages > _currentPage + 1) {
        // Itt már tudjuk, hogy kell az új oldal
        updatePage(_currentPage + 1);
      }
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
        SizedBox(height: 8.sp),
        items.isEmpty && !listStatus.baseStatus.modelState.isLoading
            ? Center(
                child: Text(
                  "base_no_items_found".i18n(),
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              )
            : items.isEmpty && listStatus.baseStatus.modelState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : buildListLayout(context, ref) ??
                    BaseListView(hasBottomPadding: true, physics: const NeverScrollableScrollPhysics(), children: children),
      ],
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
    await (ref.watch(provider.notifier) as ListApiProvider).list(filter: filter, page: pageFrom, sort: sort);
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
            child: Wrap(spacing: 8.0, runSpacing: 4.0, alignment: WrapAlignment.start, children: widgets),
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
