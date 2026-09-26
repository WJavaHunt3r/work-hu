import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/widgets/base_alert_dialog.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/icon_box.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe_transactions/data/state/bufe_transactions_state.dart';
import 'package:work_hu/features/bufe_transactions/providers/bufe_transactions_provider.dart';
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
          trailing: Text("- ${Utils.creditFormatting(e.totalPrice)}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          leading: Image.network(
            e.imageUrl,
            width: 30.sp,
          ),
        );
      }).toList()),
      onTap: () {},
    );
  }
}
