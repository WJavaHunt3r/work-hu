import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A line of a payment's details on the result pages (top-up, donation): label on the left, value on the right.
class PaymentDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const PaymentDetailRow({super.key, required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The value takes the room the label leaves and wraps (a long checkout reference breaks at its hyphens)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
        SizedBox(width: 16.sp),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[Icon(icon, size: 20.sp, color: theme.colorScheme.onSurface), SizedBox(width: 8.sp)],
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
