import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';

class OrderItems extends LegacyBasePage {
  OrderItems({super.key, super.title = "bufe_order_items"}) : super(titleArgs: [""]);

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    var items = ref.watch(bufeDataProvider).orderItems;
    var order = ref.watch(bufeDataProvider).selectedOrder;
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("bufe_order_date".i18n()),
                    Text("${order?.date}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("bufe_order_sum".i18n()),
                    Text("${order?.total} Ft"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("bufe_order_loc".i18n()),
                    Text(order?.locationName ?? ""),
                  ],
                )
              ],
            ),
          ),
        ),
        ref.watch(bufeDataProvider).modelState == ModelState.loading
            ? const CircularProgressIndicator()
            : LegacyBaseListView(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return BaseListTile(
                    isLast: index == items.length - 1,
                    index: index,
                    title: Text("${items[index].productName} * ${items[index].quantity}"),
                    trailing: Text(
                      "${items[index].totalPrice} Ft",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    subtitle: Text("Egység ár: ${items[index].unitPrice} Ft"),
                    // trailing: Text("${items[index].amount} Ft"),
                  );
                },
                itemCount: items.length,
                children: const [],
              ),
      ],
    );
  }
}
