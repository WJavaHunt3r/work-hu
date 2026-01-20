import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';

import 'base_list_view.dart';

abstract class BaseFilterChip<T> extends ConsumerStatefulWidget {
  final String label;
  final String? Function(T? item) labelValue;
  final Function() onDeleted;
  final bool? showDelete;
  final T? initialValue;
  final Function(T) onItemSelected;

  const BaseFilterChip(
      {super.key,
      required this.label,
      required this.labelValue,
      required this.onDeleted,
      required this.onItemSelected,
      this.showDelete = true,
      this.initialValue});
}

abstract class BaseFilterChipState<T, W extends BaseFilterChip<T>> extends ConsumerState<W> {
  T? _selectedItem;

  @protected
  T? get selectedItem => _selectedItem;

  @protected
  set selectedItem(T? value) {
    setState(() {
      _selectedItem = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    var labelValue = widget.labelValue(selectedItem);
    var isActive = labelValue != null && labelValue != "";
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
          label: Row(
            children: [
              Text("header_label".i18n([widget.label.i18n(), labelValue ?? ""])),
              Visibility(visible: !isActive, child: const Icon(Icons.arrow_drop_down)),
            ],
          ),
          onDeleted: !isActive || widget.showDelete == false
              ? null
              : () {
                  selectedItem = null;
                  widget.onDeleted();
                },
          selected: labelValue != null && labelValue != "",
          showCheckmark: false,
          onSelected: (bool value) => onSelected(value)),
    );
  }

  @protected
  void onSelected(bool value);
}

class ModalBottomFilterChip<T> extends BaseFilterChip<T> {
  const ModalBottomFilterChip({
    super.key,
    required super.label,
    required super.labelValue,
    required super.onDeleted,
    super.showDelete,
    required super.onItemSelected,
    required this.children,
    required this.title,
    super.initialValue,
  });

  final List<T> children;
  final Widget Function(T) title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ModalBottomFilterChipState<T>();
  }
}

class ModalBottomFilterChipState<T> extends BaseFilterChipState<T, ModalBottomFilterChip<T>> {
  @override
  void onSelected(bool value) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              onClosing: () => context.pop(),
              builder: (context) {
                return BaseListView(
                    itemBuilder: (BuildContext context, int index) {},
                    itemCount: widget.children.length,
                    children: [
                      Row(
                        children: [
                          IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
                          Text(widget.label.i18n())
                        ],
                      ),
                      ...widget.children.map((e) => ListTile(
                            title: widget.title(e),
                            leading: Radio<T>(
                              value: e,
                              groupValue: selectedItem,
                              onChanged: (value) {},
                            ),
                            onTap: () {
                              selectedItem = e;
                              widget.onItemSelected(e);
                              context.pop();
                            },
                          )),
                      const SizedBox(
                        height: 10,
                      )
                    ]);
              });
        });
  }
}

class DialogFilterChip<T> extends BaseFilterChip<T> {
  const DialogFilterChip(
      {super.key,
      required super.label,
      required super.labelValue,
      required super.onDeleted,
      super.initialValue,
      required super.onItemSelected,
      required this.children,
      required this.title});

  final Future<Iterable<T>> Function() children;
  final Widget Function(T) title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DialogFilterChipState<T>();
  }
}

class DialogFilterChipState<T> extends BaseFilterChipState<T, DialogFilterChip<T>> {
  @override
  void onSelected(bool value) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog.fullscreen(
              child: Scaffold(
            appBar: AppBar(
                title: Row(
              children: [
                Text(widget.label.i18n([":"]), style: Theme.of(context).textTheme.titleMedium)
              ],
            )),
            body: FutureBuilder(
              future: widget.children(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading data: ${snapshot.error}'));
                }
                final List<T> items = snapshot.data?.toList() ?? [];
                return BaseListView(
                  itemBuilder: (BuildContext context, int index) {},
                  itemCount: items.length,
                  children: items
                      .map((e) => ListTile(
                            title: widget.title(e),
                            tileColor:
                                selectedItem == e || widget.initialValue == e ? Theme.of(context).colorScheme.primary : null,
                            onTap: () {
                              selectedItem = e;
                              widget.onItemSelected(e);
                              context.pop();
                            },
                          ))
                      .toList(),
                );
              },
            ),
          ));
        });
  }
}

// class TextSearchFilterChip<T> extends BaseFilterChip<T> {
//   const TextSearchFilterChip({
//     super.key,
//     required super.label,
//     required super.labelValue,
//     required super.onDeleted,
//     required this.onSelectedDelegate,
//   });
//
//   final Function(bool) onSelectedDelegate;
//
//   @override
//   State<StatefulWidget> createState() {
//     return TextSearchFilterChipState<T>();
//   }
// }

// class TextSearchFilterChipState<T> extends BaseFilterChipState<T, TextSearchFilterChip<T>> {
//   @override
//   void onSelected(bool value) {
//     widget.onSelectedDelegate(value);
//   }
// }
