import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/style/app_colors.dart';

class BaseFilterChip extends ConsumerWidget {
  const BaseFilterChip({required this.isSelected, required this.title, required this.onSelected, super.key});

  final bool isSelected;
  final String title;
  final Function(bool selected) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.sp),
      child: FilterChip(
        label: Text(
          title,
          style: TextStyle(color: isSelected ? AppColors.white : Theme.of(context).colorScheme.primary),
        ),
        selected: isSelected,
        onSelected: (bool selected) => onSelected(selected),
      ),
    );
  }
}
