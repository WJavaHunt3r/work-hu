import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';

class OrderListItem extends ConsumerWidget {
  const OrderListItem({super.key, required this.isLast, required this.index, required this.order, required this.userId});

  final bool isLast;
  final int index;
  final OrderEntry order;
  final num userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseListTile(
      isLast: isLast,
      index: index,
      onTap: () {
        ref.watch(bufeDataProvider.notifier).setSelectedOrder(order);
        context.push("/profile/bufe/${userId}/orderItems");
      },
      trailing: Text(
        "${order.total} Ft",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
      ),
      title: Text("${order.date} ", style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
