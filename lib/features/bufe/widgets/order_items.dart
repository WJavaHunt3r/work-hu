import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';

class OrderItems extends BasePage {
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
                    Text("${order?.date} ${order?.time}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("bufe_order_sum".i18n()),
                    Text("${order?.brutto.replaceAll(".00", "")} Ft"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("bufe_order_loc".i18n()),
                    Text(order?.location == "BUFE1" ? "Büfé" : "Kávézó"),
                  ],
                )
              ],
            ),
          ),
        ),
        ref.watch(bufeDataProvider).modelState == ModelState.processing
            ? CircularProgressIndicator()
            : BaseListView(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return BaseListTile(
                    isLast: index == items.length - 1,
                    index: index,
                    title: Text(items[index].name),
                    trailing: Text("${items[index].price.replaceAll(".00", "")} Ft"),
                  );
                },
                itemCount: items.length,
                children: [],
              ),
      ],
    );
  }
}
