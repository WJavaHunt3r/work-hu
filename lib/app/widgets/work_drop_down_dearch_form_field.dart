import 'dart:async';

import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkDropDownSearchFormField<T> extends StatelessWidget {
  const WorkDropDownSearchFormField(
      {super.key,
      this.direction,
      required this.controller,
      this.focusNode,
      this.autofocus,
      required this.onSuggestionSelected,
      required this.itemBuilder,
      required this.suggestionsCallback,
      this.enabled,
      this.onTap});

  final AxisDirection? direction;
  final bool? autofocus;
  final bool? enabled;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(T) onSuggestionSelected;
  final Widget Function(BuildContext, T) itemBuilder;
  final Function()? onTap;
  final FutureOr<Iterable<T>> Function(String) suggestionsCallback;

  @override
  Widget build(BuildContext context) {
    return DropDownSearchField<T>(
        direction: AxisDirection.down,
        suggestionsBoxVerticalOffset: 2.sp,
        suggestionsBoxController: SuggestionsBoxController(),
        suggestionsBoxDecoration:
            SuggestionsBoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.sp), offsetX: 2),
        textFieldConfiguration: TextFieldConfiguration(
            scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            autofocus: autofocus ?? false,
            enabled: enabled ?? true,
            controller: controller,
            onTap: onTap),
        onSuggestionSelected: onSuggestionSelected,
        itemBuilder: (BuildContext context, T itemData) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 5),
                title: itemBuilder(context, itemData)),
          );
        },
        suggestionsCallback: suggestionsCallback,
        minCharsForSuggestions: 2,
        autoFlipMinHeight: 10.sp,
        displayAllSuggestionWhenTap: false);
  }
}
