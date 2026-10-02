import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

/// The decoration every form input uses (see [BaseTextFormField]): filled, rounded, outlined.
InputDecoration baseInputDecoration(ThemeData theme, {String? hintText, Widget? prefixIcon, Widget? suffixIcon}) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: theme.colorScheme.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.sp),
      borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.sp),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.sp),
    ),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  );
}

/// A form input with its label above it, laid out like [BaseTextFormField].
class BaseLabeledField extends StatelessWidget {
  const BaseLabeledField({super.key, required this.labelText, required this.child, this.padding});

  final String labelText;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding ?? EdgeInsets.all(8.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText.i18n(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8.sp),
          child,
        ],
      ),
    );
  }
}

/// A dropdown styled like the other form inputs.
class BaseDropdownFormField<T> extends StatelessWidget {
  const BaseDropdownFormField({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.padding,
  });

  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final T? initialValue;
  final FormFieldValidator<T>? validator;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return BaseLabeledField(
      labelText: labelText,
      padding: padding,
      child: DropdownButtonFormField<T>(
        isExpanded: true,
        borderRadius: BorderRadius.circular(8.sp),
        decoration: baseInputDecoration(Theme.of(context)),
        initialValue: initialValue,
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
