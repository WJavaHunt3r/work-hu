import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class BaseSortWidget extends StatefulWidget {
  const BaseSortWidget({super.key, required this.sortParameters, required this.onSelected});

  final List<SortItem> sortParameters;
  final Function(SortItem) onSelected;

  @override
  State<StatefulWidget> createState() {
    return BaseSortWidgetState();
  }
}

class BaseSortWidgetState extends State<BaseSortWidget> {
  List<SortItem> get sortParameters => widget.sortParameters;

  Function(SortItem) get onSelected => widget.onSelected;

  late SortItem? selected;

  @override
  void initState() {
    super.initState();
    selected = sortParameters.isNotEmpty ? sortParameters.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return sortParameters.isEmpty
        ? const SizedBox()
        : PopupMenuButton(
            icon: const Icon(Icons.filter_list),
            onSelected: (e) {
              setState(() {
                selected = e;
              });
              onSelected(e);
            },
            color: Theme.of(context).colorScheme.primary,
            offset: const Offset(0, 50),
            itemBuilder: (context) {
              return sortParameters
                  .map((e) => PopupMenuItem<SortItem>(
                        value: e,
                        child: Row(
                          children: [
                            Text(
                              "${e.label.i18n()} ${"order_by".i18n()} ${e.ascending == "1" ? "asc".i18n() : "desc".i18n()}",
                              style: const TextStyle(color: Colors.black),
                            ),
                            const Spacer(),
                            if (e.value == selected?.value && e.ascending == selected?.ascending)
                              const Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                          ],
                        ),
                      ))
                  .toList();
            });
  }
}

class SortItem {
  final String label;
  final String value;
  final String ascending;

  SortItem({required this.label, required this.value, required this.ascending});
}
