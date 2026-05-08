import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';

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
  late ScrollController _scrollController;
  late int _currentPage;

  ScrollController get scrollController => _scrollController;
  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void updatePage(int i) {
    setState(() {
      _currentPage = i;
      list(pageFrom: _currentPage);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        listStatus.totalPages > _currentPage + 1) {
      updatePage(++_currentPage);
    }
  }

  @override
  ScrollController? getController() {
    return _scrollController;
  }

  @override
  Widget buildLayout() {
    var headers = HeaderChipLayout(buildChildren: (filterContext) => buildHeaderLayout(filterContext, ref));
    var children = items
        .map((e) => Dismissible(key: UniqueKey(), onDismissed: (direction) => onDelete(), child: buildListTiles(e)))
        .toList();
    return RefreshIndicator(
      onRefresh: () async {
        if (ref.read(provider.notifier) is ListApiProvider) {
          updatePage(0);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          headers,
          FilterChipLayout(
            buildChildren: (filterContext) => buildFilterLayout(filterContext, ref),
            filterValues: getFilters(),
            totalElements: listStatus.totalElements,
            listLength: items.length,
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
                      BaseListView(hasBottomPadding: false, physics: const NeverScrollableScrollPhysics(), children: children),
        ],
      ),
    );
  }

  Widget buildListTiles(dynamic item) => ListTile(title: Text(item.toString()));

  List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) {
    return [];
  }

  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) {
    return [];
  }

  Widget? buildListLayout(BuildContext context, WidgetRef ref) => null;

  List get items;

  Future<void> list({dynamic filter, int? pageFrom = 0}) async {
    await (ref.watch(provider.notifier) as ListApiProvider).list(filter: filter, page: pageFrom);
  }

  BaseListState get listStatus;

  @override
  BaseState get status => listStatus.baseStatus;

  List<dynamic> getFilters();

  void onDelete() {}
}

class FilterChipLayout extends StatelessWidget {
  final List<BaseFilterChip> Function(BuildContext) buildChildren;
  final bool isFilter;

  // final Function(SortItem)? onSelected;

  final List<dynamic> filterValues;

  const FilterChipLayout({
    super.key,
    required this.buildChildren,
    this.isFilter = true,
    // this.onSelected,
    required this.totalElements,
    required this.listLength,
    required this.filterValues,
  });

  final int totalElements;
  final int listLength;

  @override
  Widget build(BuildContext context) {
    var widgets = buildChildren(context);
    // if (widgets.isEmpty) return const SizedBox();
    var text = "$listLength/$totalElements";
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft, // Ensures the Wrap doesn't try to center stack
            child: Wrap(spacing: 8.0, runSpacing: 4.0, alignment: WrapAlignment.start, children: widgets),
          ),
        ),
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
