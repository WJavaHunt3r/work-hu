import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_alert_dialog.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/widgets/base_list_item.dart';

class BufeTransactionItemsPage extends StatelessWidget {
  const BufeTransactionItemsPage({super.key, required this.items});

  final List<OrderItem> items;

  @override
  Widget build(BuildContext context) {
    return BaseAlertDialog(
      cancelVisible: false,
      title: 'bufe_transaction_items_title',
      content: BaseListView(
        children: items.map((e) {
          var index = items.indexOf(e);
          return BaseListTile(
            isLast: index == items.length - 1,
            index: index,
            title: Text("${e.productName} x ${e.quantity} "),
            subtitle: Text(Utils.creditFormatting(e.unitPrice)),
            trailing: Text(
              "- ${Utils.creditFormatting(e.totalPrice)}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            leading: Image.network(e.imageUrl, width: 30.sp),
          );
        }).toList(),
      ),
      onTap: () {},
    );
  }
}
