import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_goal.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/payments/data/model/payments_filter.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/providers/payments_provider.dart';
import 'package:work_hu/features/payments/widgets/payments_maintenance.dart';
import 'package:work_hu/features/utils.dart';

class PaymentsPage extends BaseListPage {
  const PaymentsPage({super.key, this.donationId, this.userId, super.title = "payments"});

  final num? donationId;
  final num? userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PaymentsPageState();
  }
}

class PaymentsPageState extends PagedListPageState<PaymentsPage, PaymentsModel, PaymentsFilter, PaymentDataNotifier> {
  @override
  get provider => paymentDataProvider(PaymentsFilter(donationId: widget.donationId, userId: widget.userId));

  @override
  Widget build(BuildContext context) {
    // The base page only reports errors of the list provider.
    ref.listen(paymentDetailProvider, (previous, next) {
      if (next.status.modelState.isError && !(previous?.status.modelState.isError ?? false)) {
        Utils.showErrorDialog(context, content: next.status.message.i18n());
      }
    });
    return super.build(context);
  }

  @override
  Widget buildListTile(PaymentsModel item, int index) {
    var date = item.dateTime;
    var dateString = Utils.dateToString(date);
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => showDialog(
        context: context,
        builder: (buildContext) {
          return ConfirmAlertDialog(
            onConfirm: () => buildContext.pop(true),
            title: "base_delete".i18n(),
            content: Text("payment_delete_warning".i18n(), textAlign: TextAlign.center),
          );
        },
      ).then((confirmed) => confirmed == true ? notifier.deletePayment(item) : null),
      dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
      child: BaseListTile(
        isLast: items.length - 1 == index,
        index: index,
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => PaymentMaintenance(paymentId: item.id!),
          );
        },
        trailing: Text(
          Utils.creditFormat.format(item.amount),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            decoration: item.status == PaymentStatus.FAILED || item.status == PaymentStatus.EXPIRED
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        title: Text(item.description.toString()),
        leading: Icon(item.paymentGoal == PaymentGoal.DONATION ? Icons.attach_money : Icons.credit_card),
        subtitle: Row(
          children: [
            getPaymentText(item.status),
            Expanded(
              child: Text(
                " - $dateString ${item.user != null ? "- ${item.user!.getFullName()}" : ""}",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPaymentText(PaymentStatus status) {
    var iconColor = switch (status) {
      PaymentStatus.FAILED => Colors.red,
      PaymentStatus.PENDING => Colors.grey,
      PaymentStatus.PAID => Colors.green,
      PaymentStatus.EXPIRED => Colors.red,
    };

    var icon = switch (status) {
      PaymentStatus.FAILED => Icons.cancel_outlined,
      PaymentStatus.PENDING => Icons.pending_outlined,
      PaymentStatus.PAID => Icons.done,
      PaymentStatus.EXPIRED => Icons.delete_forever_outlined,
    };

    var text = switch (status) {
      PaymentStatus.FAILED => "payment_status_failed",
      PaymentStatus.PENDING => "payment_status_pending",
      PaymentStatus.PAID => "payment_status_paid",
      PaymentStatus.EXPIRED => "payment_status_expired",
    };

    return Row(
      children: [
        Icon(icon, size: 14.sp, color: iconColor),
        Text(text.i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    return [IconButton(onPressed: () => notifier.refreshPayments(), icon: const Icon(Icons.refresh))];
  }
}
