import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/title_provider.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/bufe/widgets/order_list_item.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';
import 'package:work_hu/features/utils.dart';

class BufeLayout extends ConsumerStatefulWidget {
  const BufeLayout({
    super.key,
    this.onTrack,
    required this.userId,
  });

  final bool? onTrack;
  final num userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BufeState();
  }
}

class _BufeState extends ConsumerState<BufeLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bufeDataProvider.notifier).getAccounts(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
        bufeDataProvider,
        (prev, next) =>
            next.account != null ? ref.read(titleDataProvider.notifier).setTitle(next.account?.full_name ?? "") : null);
    final account = ref.watch(bufeDataProvider).account;
    final payments = ref.watch(bufeDataProvider).payments;
    final orders = ref.watch(bufeDataProvider).orders;
    return account == null && ref.watch(bufeDataProvider).modelState != ModelState.loading
        ? Center(
            child: Text("bufe_no_user".i18n()),
          )
        : RefreshIndicator(
            onRefresh: () async {
              ref.read(bufeDataProvider.notifier).getAccounts(widget.userId);
            },
            child: SingleChildScrollView(
              child: Stack(children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: InfoCard(
                                height: 140.sp,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("bufe_sum".i18n(), style: Theme.of(context).textTheme.titleSmall),
                                    Text("${Utils.creditFormat.format(account?.spent ?? 0)} Ft",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(fontWeight: FontWeight.w700, fontSize: 30.sp)),
                                  ],
                                ))),
                        Expanded(
                            child: InfoCard(
                                height: 140.sp,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("bufe_payments_sum".i18n(), style: Theme.of(context).textTheme.titleSmall),
                                    Text(
                                      "${Utils.creditFormat.format(account?.spent ?? 0)} Ft",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontWeight: FontWeight.w700, fontSize: 30.sp),
                                    ),
                                  ],
                                )))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("bufe_orders".i18n(), style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                    ),
                    LegacyBaseListView(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return OrderListItem(
                            isLast: index == orders.length - 1, index: index, order: orders[index], userId: widget.userId);
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ref.watch(bufeDataProvider).orders.length,
                      shadowColor: Colors.transparent,
                      cardBackgroundColor: Colors.transparent,
                      children: const [],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("bufe_payments".i18n()),
                      ],
                    ),
                    LegacyBaseListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return listItem(payments, context, index, ref);
                      },
                      itemCount: ref.watch(bufeDataProvider).payments.length,
                      shadowColor: Colors.transparent,
                      cardBackgroundColor: Colors.transparent,
                      children: const [],
                    ),
                  ],
                ),
                ref.watch(bufeDataProvider).modelState == ModelState.error
                    ? Center(
                        child: Text(
                          ref.watch(bufeDataProvider).message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.errorRed),
                        ),
                      )
                    : const SizedBox(),
                ref.watch(bufeDataProvider).modelState == ModelState.loading
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox()
              ]),
            ),
          );
  }

  Widget listItem(List<TopUpEntry> items, BuildContext context, int index, WidgetRef ref) {
    var current = items[index];
    var date = current.createdAt;
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
          Text(date.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
