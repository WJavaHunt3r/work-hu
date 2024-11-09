import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/bufe/data/model/bufe_payments_model.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/bufe/widgets/account_balance.dart';
import 'package:work_hu/features/utils.dart';

class BufeLayout extends ConsumerWidget {
  const BufeLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(bufeDataProvider).accounts;
    final items = ref.watch(bufeDataProvider).payments;
    return Stack(children: [
      Column(children: [
        for (var account in accounts)
          AccountBalance(
            name: account.name,
            balance: account.balance,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Befizetések"),
          ],
        ),
        Expanded(
            child: BaseListView(
          itemBuilder: (BuildContext context, int index) {
            return listItem(items, context, index, ref);
          },
          itemCount: ref.watch(bufeDataProvider).payments.length,
          shadowColor: Colors.transparent,
          cardBackgroundColor: Colors.transparent,
          children: const [],
        ))
      ]),
      ref.watch(bufeDataProvider).modelState == ModelState.error
          ? Center(
              child: Text(
                ref.watch(bufeDataProvider).message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.errorRed),
              ),
            )
          : const SizedBox(),
      ref.watch(bufeDataProvider).modelState == ModelState.processing
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox()
    ]);
  }

  Widget listItem(List<BufePaymentsModel> items, BuildContext context, int index, WidgetRef ref) {
    var current = items[index];
    var date = current.date;
    return BaseListTile(
      isLast: items.length - 1 == index,
      index: index,
      onTap: () {},
      trailing: Text(
        "${current.amount} Ft",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
      ),
      title: Row(
        children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
