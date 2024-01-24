import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseTextFormField extends StatelessWidget {
  const BaseTextFormField(
      {super.key, required this.initialValue, required this.labelText, this.enabled = true, required this.onChanged});

  final String initialValue;
  final String labelText;
  final bool enabled;
  final Function(String text) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.sp),
      child: TextFormField(
        enabled: enabled,
        initialValue: initialValue,
        decoration: InputDecoration(fillColor: Colors.transparent, labelText: labelText),
        onChanged: (String text) => onChanged(text),
      ),
    );
  }
}
