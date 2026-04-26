import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';

class BaseTextFormField extends StatefulWidget {
  const BaseTextFormField({super.key,
    this.initialValue,
    required this.labelText,
    this.enabled = true,
    this.onChanged,
    this.textAlign = TextAlign.left,
    this.keyBoardType = TextInputType.text,
    this.autofocus = false,
    this.controller,
    this.autofillHints,
    this.focusNode,
    this.textStyle,
    this.textInputAction,
    this.obscureText = false,
    this.validator,
    this.fillColor,
    this.onFieldSubmitted,
    this.isPasswordField = false,
    this.suffix,
    this.prefix,
    this.inputFormatter,
    this.fldControl,
    this.onTap,
    this.maxLines = 1,
    this.fontSize,
    this.isHighLighted = false,
    this.onEditingComplete})
      : assert(initialValue != Widget);

  final Object? initialValue;
  final String labelText;
  final bool enabled;
  final bool autofocus;
  final TextAlign textAlign;
  final TextInputType keyBoardType;
  final TextEditingController? controller;
  final List<String>? autofillHints;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final bool obscureText;
  final bool isPasswordField;
  final String? Function(String?)? validator;
  final Function(String text)? onChanged;
  final Function(String text)? onFieldSubmitted;
  final Function()? onEditingComplete;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputFormatter? inputFormatter;
  final String? fldControl;
  final Function()? onTap;
  final int? maxLines;
  final double? fontSize;
  final bool isHighLighted;

  @override
  State<StatefulWidget> createState() => _BaseTextFormFieldState();
}

class _BaseTextFormFieldState extends State<BaseTextFormField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void obscuredChanged() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    var enabled = widget.enabled && (widget.fldControl == null || widget.fldControl != "1");
    var highlightColor = Theme
        .of(context)
        .textTheme
        .bodyMedium
        ?.color;
    return Visibility(
      visible: widget.fldControl == null || (widget.fldControl != "0" && widget.fldControl != ""),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
        child: TextFormField(
          autofillHints: widget.autofillHints,
          focusNode: widget.focusNode,
          enabled: enabled,
          textAlign: widget.textAlign,
          controller: widget.controller,
          keyboardType: widget.keyBoardType,
          initialValue: widget.initialValue?.toString(),
          autofocus: widget.autofocus,
          textInputAction: widget.textInputAction,
          obscureText: _isObscured,
          style: enabled && !widget.isHighLighted
              ? null
              : Theme
              .of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
              fontSize: widget.isHighLighted ? (Theme
                  .of(context)
                  .textTheme
                  .bodyMedium
                  ?.fontSize ?? 0) + 8 : widget.fontSize,
              color: widget.isHighLighted ? highlightColor : Theme
                  .of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withAlpha(180)),
          inputFormatters: widget.inputFormatter == null ? null : [widget.inputFormatter!],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 16, top: 12),
            // enabledBorder: const OutlineInputBorder(),
            border: widget.isHighLighted
                ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: highlightColor!,
                  width: 1,
                ))
                : OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withAlpha(100), // Light blue border for disabled
                  width: 1,
                )),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withAlpha(100), // Light blue border for disabled
                width: 1,
              ),
            ),
            label: widget.fldControl == "3"
                ? RichText(
                text: TextSpan(
                    text: widget.labelText,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    children: const [
                      TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                          ))
                    ]))
                : null,
            labelStyle: enabled
                ? null
                : Theme
                .of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Theme
                .of(context)
                .textTheme
                .labelLarge
                ?.color
                ?.withAlpha(180)),
            labelText: widget.fldControl == "3" ? null : widget.labelText,
            fillColor: widget.fillColor,
            prefixIcon: widget.prefix,
            suffixIcon: widget.isPasswordField
                ? IconButton(
              onPressed: () => obscuredChanged(),
              icon: _isObscured ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
            )
                : widget.suffix,
          ),
          onChanged: widget.onChanged != null ? (String text) => widget.onChanged!(text) : null,
          onFieldSubmitted: widget.onFieldSubmitted != null ? (String text) => widget.onFieldSubmitted!(text) : null,
          // onEditingComplete: widget.onEditingComplete != null ? () => widget.onEditingComplete!() : null,
          // onTapOutside: (event)=> widget.onEditingComplete != null ? () => widget.onEditingComplete!() : null,
          validator: widget.fldControl != "3"
              ? null
              : (String? text) =>
          widget.validator != null
              ? widget.validator!(text)
              : (text == null || text.isEmpty ? "base_is_required".i18n() : null),
          onTap: widget.onTap,
          maxLines: widget.maxLines,
        ),
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  final pattern = "yyyy.MM.dd";

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Apply the pattern
    if (text.length > 8) {
      text = text.substring(0, 8);
    }

    String formattedText = '';
    if (text.isNotEmpty) {
      formattedText += text.substring(0, text.length.clamp(0, 4));
    }
    if (text.length > 4) {
      formattedText += '.${text.substring(4, text.length.clamp(4, 6))}';
    }
    if (text.length > 6) {
      formattedText += '.${text.substring(6, text.length.clamp(6, 8))}';
    }

    // Determine the new cursor position
    int newCursorPosition = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}

class ThreeDigitDecimalFormatter extends TextInputFormatter {
  // Regex explanation:
  // ^[0-9]* -> Start with zero or more digits (integer part)
  // ([\.]?[0-9]{0,3})? -> Optionally match the decimal part:
  //    [\.]? -> Zero or one decimal separator (dot).
  //    [0-9]{0,3} -> Followed by zero to three digits.
  // $ -> End of the string.
  static final RegExp _decimalExp = RegExp(r'^[0-9]*([\,]?[0-9]{0,3})?$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue,) {
    // 1. If the new value is empty, allow it.
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // 2. Check if the new text matches the required pattern.
    if (_decimalExp.hasMatch(newValue.text)) {
      // If it matches, allow the change.
      return newValue;
    }

    // 3. If it does NOT match (e.g., trying to type a fourth decimal place),
    // revert to the old value, effectively blocking the invalid input.
    return oldValue;
  }
}

class NoDecimalFormatter extends TextInputFormatter {
  // Regex explanation:
  // ^[0-9]* -> Start with zero or more digits (integer part)
  // ([\.]?[0-9]{0,3})? -> Optionally match the decimal part:
  //    [\.]? -> Zero or one decimal separator (dot).
  //    [0-9]{0,3} -> Followed by zero to three digits.
  // $ -> End of the string.
  static final RegExp _decimalExp = RegExp(r'^[0-9]*$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue,) {
    // 1. If the new value is empty, allow it.
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // 2. Check if the new text matches the required pattern.
    if (_decimalExp.hasMatch(newValue.text)) {
      // If it matches, allow the change.
      return newValue;
    }

    // 3. If it does NOT match (e.g., trying to type a fourth decimal place),
    // revert to the old value, effectively blocking the invalid input.
    return oldValue;
  }
}
