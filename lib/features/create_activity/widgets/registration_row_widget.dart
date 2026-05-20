import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/utils.dart';

class RegistrationRowWidget extends ConsumerWidget {
  const RegistrationRowWidget(
      {super.key, required this.index, required this.name, required this.value, required this.isLast, required this.onTap});

  final num index;
  final String name;
  final num value;
  final bool isLast;
  final Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var style = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp);
    return Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              padding: EdgeInsets.symmetric(horizontal: 4.sp),
              borderRadius: index == 0 && isLast
                  ? BorderRadius.only(topRight: Radius.circular(24.sp), bottomRight: Radius.circular(24.sp))
                  : index == 0
                      ? BorderRadius.only(topRight: Radius.circular(24.sp))
                      : isLast
                          ? BorderRadius.only(bottomRight: Radius.circular(24.sp))
                          : BorderRadius.zero,
              onPressed: (context) => ref.read(createActivityDataProvider.notifier).deleteRegistration(index.toInt()),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: 'base_delete'.i18n(),
            ),
          ],
        ),
        child: BaseListTile(
          tileColor: value > 10 ? AppColors.redRowBgColor : Theme.of(context).colorScheme.surfaceContainerHighest,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
          isLast: isLast,
          index: index.toInt(),
          leading: Text(
            (index + 1).toString(),
            style: style,
          ),
          title: Text(name, style: style),
          trailing: Text(
            "${value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1)} ${Utils.getTransactionTypeText(TransactionType.HOURS, false)}",
            style: style,
          ),
          onTap: onTap.call(),
        ));
  }
}
