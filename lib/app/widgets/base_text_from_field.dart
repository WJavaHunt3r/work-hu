import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseTextFormField extends StatelessWidget {
  const BaseTextFormField(
      {super.key,
      required this.initialValue,
      required this.labelText,
      this.enabled = true,
      required this.onChanged,
      this.textAlign = TextAlign.right,
      this.keyBoardType = TextInputType.text});

  final String initialValue;
  final String labelText;
  final bool enabled;
  final TextAlign textAlign;
  final TextInputType keyBoardType;
  final Function(String text) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.sp, bottom: 8.sp),
      child: TextFormField(
        enabled: enabled,
        textAlign: textAlign,
        keyboardType: keyBoardType,
        initialValue: initialValue,
        decoration: InputDecoration(
            fillColor: enabled ? Colors.white : Colors.transparent,
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 15.sp)),
        onChanged: (String text) => onChanged(text),
      ),
    );
  }
}
