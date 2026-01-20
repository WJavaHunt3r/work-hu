import 'package:flutter/material.dart';
import 'package:work_hu/app/widgets/base_sort_widget.dart';

import 'base_filter_chip.dart';

class FilterChipLayout extends StatelessWidget {
  final List<BaseFilterChip> Function(BuildContext) buildChildren;
  final bool isFilter;
  final Function(SortItem)? onSelected;
  final List<SortItem>? sortParameters;
  final List<dynamic> filterValues;

  const FilterChipLayout(
      {super.key,
        required this.buildChildren,
        this.isFilter = true,
        this.onSelected,
        this.sortParameters,
        required this.filterValues})
      : assert(!isFilter || (onSelected != null && sortParameters != null));

  @override
  Widget build(BuildContext context) {
    var widgets = buildChildren(context);
    var activeFilter = filterValues.where((e) => e != null && e != "" && e != 0).toList().length;
    return widgets.isEmpty
        ? const SizedBox()
        : Expanded(
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.filter_alt_outlined),
                ),
                Visibility(
                  visible: activeFilter > 0,
                  child: Positioned(
                      right: 4,
                      child: Badge(
                        label: Text(
                          activeFilter.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        backgroundColor: Colors.redAccent,
                      )),
                )
              ],
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  ...widgets,
                ],
              ),
            ),
            BaseSortWidget(sortParameters: sortParameters ?? [], onSelected: (value) => onSelected!(value))
          ],
        ),
      ),
    );
  }
}