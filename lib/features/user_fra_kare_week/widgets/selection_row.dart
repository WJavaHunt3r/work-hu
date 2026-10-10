import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/user_fra_kare_week/data/model/user_fra_kare_week_model.dart';

class SelectionRow extends StatelessWidget {
  const SelectionRow({
    required this.fraKareWeek,
    required this.isLast,
    required this.index,
    required this.onChanged,
    super.key,
  });

  final UserFraKareWeekModel fraKareWeek;
  final bool isLast;
  final int index;
  final void Function(bool listened) onChanged;

  @override
  Widget build(BuildContext context) {
    return BaseListTile(
      leading: Text(
        fraKareWeek.user.getFullName(),
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
      ),
      trailing: Checkbox.adaptive(
        activeColor: Theme.of(context).colorScheme.primary,
        value: fraKareWeek.listened,
        onChanged: (changed) => onChanged(changed ?? false),
      ),
      isLast: isLast,
      index: index,
      title: SizedBox(),
    );
  }
}
