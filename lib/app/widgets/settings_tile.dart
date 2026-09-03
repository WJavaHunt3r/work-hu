import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/icon_box.dart';

class SettingsTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? trailingText;
  final Function? onTap;
  final bool isLast;
  final int index;

  const SettingsTile(
      {required this.label, required this.icon, this.trailingText, this.onTap, this.isLast = false, this.index = 1});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseListTile(
      contentPadding: EdgeInsets.all(18.sp),
      leading: IconBox(
        icon: icon,
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText!, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          SizedBox(width: 8.sp),
          Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
        ],
      ),
      onTap: () => onTap?.call(),
      isLast: isLast,
      index: index,
    );
  }
}