import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/user_fra_kare_week/data/model/user_fra_kare_week_model.dart';
import 'package:work_hu/features/user_fra_kare_week/provider/user_fra_kare_week_provider.dart';

class SelectionRow extends ConsumerWidget {
  const SelectionRow({required this.fraKareWeek, required this.isLast, required this.index, super.key});

  final UserFraKareWeekModel fraKareWeek;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseListTile(
      leading: Text(fraKareWeek.user.getFullName(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
      trailing: Checkbox(
          value: fraKareWeek.listened,
          onChanged: (changed) =>
              ref.read(userFraKareWeekDataProvider.notifier).setUserFraKareWeeks(fraKareWeek, changed ?? false)),
      isLast: isLast,
      index: index,
    );
  }
}
