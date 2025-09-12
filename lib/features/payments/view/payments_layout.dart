import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_goal.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/payments/providers/payments_provider.dart';
import 'package:work_hu/features/payments/widgets/payment_filter.dart';
import 'package:work_hu/features/payments/widgets/payments_maintenance.dart';
import 'package:work_hu/features/utils.dart';

class PaymentsLayout extends ConsumerStatefulWidget {
  const PaymentsLayout({
    super.key,
    this.donationId,
    this.userId,
  });

  final num? donationId;
  final num? userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentsState();
}

class _PaymentsState extends ConsumerState<PaymentsLayout> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(seconds: 1),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentDataProvider.notifier).presetFilter(donationId: widget.donationId, userId: widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var payments = ref.watch(paymentDataProvider).payments;
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async => ref.read(paymentDataProvider.notifier).getPayments(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextButton(
              onPressed: () => showPaymentFilter(context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.filter_alt_outlined), Text('base_text_filter')],
              ),
            ),
            Expanded(
                child: BaseListView(
              itemBuilder: (BuildContext context, int index) {
                var current = payments[index];
                var date = current.dateTime;
                var dateString = Utils.dateToString(date);
                return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) => showDialog(
                            context: context,
                            builder: (buildContext) {
                              return ConfirmAlertDialog(
                                onConfirm: () => buildContext.pop(true),
                                title: "delete".i18n(),
                                content: Text("payment_delete_warning".i18n(), textAlign: TextAlign.center),
                              );
                            })
                        .then((confirmed) => confirmed != null && confirmed
                            ? ref.read(paymentDataProvider.notifier).deletePayments(current.id!, index, current.checkoutId)
                            : null),
                    dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
                    child: Card(
                      margin: const EdgeInsets.all(0),
                      child: BaseListTile(
                        isLast: payments.length - 1 == index,
                        index: index,
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => PaymentMaintenance(
                                    paymentId: current.id!,
                                  ));
                        },
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(current.description.toString()),
                            Text(
                              "${Utils.creditFormat.format(current.amount)} Ft",
                              style: TextStyle(
                                  decoration: current.status == PaymentStatus.FAILED || current.status == PaymentStatus.EXPIRED
                                      ? TextDecoration.lineThrough
                                      : null),
                            )
                          ],
                        ),
                        leading: Icon(current.paymentGoal == PaymentGoal.DONATION ? Icons.attach_money : Icons.credit_card),
                        subtitle: Row(
                          children: [
                            getPaymentText(current.status),
                            Expanded(
                                child: Text(
                              " - $dateString ${current.user != null ? "- ${current.user!.getFullName()}" : ""}",
                              overflow: TextOverflow.ellipsis,
                            )),
                          ],
                        ),
                      ),
                    ));
              },
              itemCount: payments.length,
              shadowColor: Colors.transparent,
              cardBackgroundColor: Colors.transparent,
              children: const [],
            ))
          ]),
        ),
        if (ref.watch(paymentDataProvider).modelState == ModelState.processing)
          const Dialog(
            backgroundColor: Colors.transparent,
            child: Center(child: CircularProgressIndicator()),
          )
      ],
    );
  }

  Widget getPaymentText(PaymentStatus status) {
    var iconColor = switch (status) {
      PaymentStatus.FAILED => Colors.red,
      PaymentStatus.PENDING => Colors.grey,
      PaymentStatus.PAID => Colors.green,
      PaymentStatus.EXPIRED => Colors.red
    };

    var icon = switch (status) {
      PaymentStatus.FAILED => Icons.cancel_outlined,
      PaymentStatus.PENDING => Icons.pending_outlined,
      PaymentStatus.PAID => Icons.done,
      PaymentStatus.EXPIRED => Icons.delete_forever_outlined
    };

    var text = switch (status) {
      PaymentStatus.FAILED => "payment_status_failed",
      PaymentStatus.PENDING => "payment_status_pending",
      PaymentStatus.PAID => "payment_status_paid",
      PaymentStatus.EXPIRED => "payment_status_expired"
    };

    return Row(
      children: [
        Icon(
          icon,
          size: 14.sp,
          color: iconColor,
        ),
        Text(
          text.i18n(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<dynamic> showPaymentFilter(BuildContext context) async {
    return await showModalBottomSheet<BasePage>(
        context: context,
        isDismissible: false,
        enableDrag: false,
        transitionAnimationController: _controller,
        elevation: 4.sp,
        isScrollControlled: true,
        barrierLabel: 'text'.i18n(),
        builder: (modalContext) {
          return PaymentFilter();
        });
  }
}
