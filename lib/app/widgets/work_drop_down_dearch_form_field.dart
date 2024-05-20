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
    return DropDownSearchFormField<T>(
        direction: AxisDirection.down,
        suggestionsBoxVerticalOffset: 0.h,
        transitionBuilder: (context, suggestionsBox, controller) => suggestionsBox,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.sp),
            closeSuggestionBoxWhenTapOutside: false,
            offsetX: 2.h,
        constraints: BoxConstraints(minHeight: 15.h)),
        textFieldConfiguration: TextFieldConfiguration(
            scrollPadding: EdgeInsets.only(bottom: 2.sp),
            autofocus: autofocus ?? false,
            enabled: enabled ?? true,
            controller: controller,
            onTap: onTap),
        onSuggestionSelected: onSuggestionSelected,
        itemBuilder: (BuildContext context, T itemData) {
          return ListTile(
              // contentPadding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 5),
              title: itemBuilder(context, itemData));
        },
        suggestionsCallback: suggestionsCallback,
        minCharsForSuggestions: 2,
        displayAllSuggestionWhenTap: false);
  }
}
