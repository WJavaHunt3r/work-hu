import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/utils.dart';

class RegistrationRowWidget extends ConsumerWidget {
  const RegistrationRowWidget(
      {super.key, required this.index, required this.name, required this.value, required this.isLast});

  final num index;
  final String name;
  final num value;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var style = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp);
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) => ref.read(createActivityDataProvider.notifier).deleteRegistration(index.toInt()),
        dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
        child: Card(
          child: BaseListTile(
            isLast: isLast,
            index: index.toInt(),
            tileColor: value > 10 ? AppColors.redRowBgColor : null,
            leading: Text(
              (index + 1).toString(),
              style: style,
            ),
            title: Text(name, style: style),
            trailing: Text(
              "${value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1)} ${Utils.getTransactionTypeText(TransactionType.HOURS, false)}",
              style: style,
            ),
          ),
        ));
  }
}
