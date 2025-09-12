import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/app_theme_mode.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
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
          style: TextStyle(
              color: isSelected
                  ? AppColors.white
                  : ref.watch(themeProvider) == AppThemeMode.dark
                      ? AppColors.primary100
                      : AppColors.primary),
        ),
        // checkmarkColor: isSelected ? AppColors.white : AppColors.primary,
        selected: isSelected,
        // color: WidgetStateColor.resolveWith((states) {
        //   if (states.contains(WidgetState.selected)) {
        //     return AppColors.primary;
        //   }
        //   return Colors.transparent;
        // }),
        onSelected: (bool selected) => onSelected(selected),
      ),
    );
  }
}
