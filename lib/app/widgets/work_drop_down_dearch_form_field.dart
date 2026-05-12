import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';

import 'base_list_item.dart';
import 'base_list_view.dart';

class DropDownSearchFormField<T extends Object> extends StatelessWidget {
  const DropDownSearchFormField(
      {super.key,
      required this.controller,
      required this.onSuggestionSelected,
      required this.itemBuilder,
      required this.suggestionsCallback,
      required this.labelText,
      this.enabled,
      this.fldControl = "1",
      this.padding = 8.0,
      this.suffix,
      this.prefix,
      this.onTap,
      required this.getLabel,
      required this.focusNode});

  final TextEditingController controller;
  final Function(T) onSuggestionSelected;
  final Widget Function(BuildContext, T) itemBuilder;
  final FutureOr<Iterable<T>> Function(String) suggestionsCallback;
  final String labelText;
  final bool? enabled;
  final String? fldControl;
  final double padding;
  final Widget? suffix;
  final Widget? prefix;
  final Function(TextEditingController controller)? onTap;
  final Function(T option) getLabel;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    var isEnabled = enabled ?? true && (fldControl == null || fldControl != "1");

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: padding),
      child: LayoutBuilder(
        // Fontos a szélesség rögzítéséhez
        builder: (context, constraints) {
          return Autocomplete<T>(
            textEditingController: controller,
            focusNode: focusNode,
            displayStringForOption: (T option) => getLabel(option),
            // A vezérlést a controller végzi
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text.length <= 2) return const Iterable.empty();
              return await suggestionsCallback(textEditingValue.text);
            },
            onSelected: onSuggestionSelected,

            // A beviteli mező testreszabása
            fieldViewBuilder: (context, fieldController, innerFocusNode, onFieldSubmitted) {
              // Szinkronizáljuk a külső controllert a belsővel, ha szükséges
              if (controller.text != fieldController.text && fieldController.text.isEmpty) {
                Future.microtask(() {
                  fieldController.text = controller.text;
                });
              }

              return BaseTextFormField(
                padding: EdgeInsets.zero,
                controller: controller,
                focusNode: innerFocusNode,
                fldControl: fldControl,
                enabled: isEnabled,
                suffix: suffix ?? const Icon(Icons.keyboard_arrow_down_outlined),
                prefix: prefix,
                labelText: labelText,
                onTap: () => onTap?.call(fieldController),
                onTapOutside: () => innerFocusNode.unfocus(),
              );
            },

            optionsMaxHeight: 600.sp,
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(12.sp),
                  color: Colors.transparent,
                  child: Container(
                    color: Colors.transparent,
                    constraints: BoxConstraints(maxHeight: 600.sp),
                    child: BaseListView(
                      hasBottomPadding: false,
                      shrinkWrap: true,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      children: options
                          .map((e) => BaseListTile(
                              tileColor: Colors.transparent,
                              title: itemBuilder(context, e),
                              onTap: () => onSelected(e),
                              isLast: options.toList().indexOf(e) == options.length,
                              index: options.toList().indexOf(e)))
                          .toList(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
