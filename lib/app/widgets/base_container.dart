import 'package:flutter/material.dart';

class BaseContainer extends StatelessWidget {
  const BaseContainer({super.key, required this.child, this.height, this.width, this.padding, this.color, this.onTap});

  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final Color? color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
          padding: padding ?? const EdgeInsets.all(24),
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24),
              boxShadow: Theme.of(context).brightness == Brightness.dark
                  ? null
                  : [
                      BoxShadow(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2), blurRadius: 5, spreadRadius: 2)
                    ]),
          child: child),
    );
  }
}
