import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:shimmer/shimmer.dart' show Shimmer;
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_goal.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/payment_success/providers/payment_success_provider.dart';
import 'package:work_hu/features/payments/providers/payments_provider.dart';
import 'package:work_hu/features/payments/widgets/payments_maintenance.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/widgets/list_separator.dart';

class PaymentSuccessLayout extends ConsumerStatefulWidget {
  const PaymentSuccessLayout({
    super.key,
    this.checkoutReference,
    this.bufeId,
  });

  final String? checkoutReference;
  final num? bufeId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends ConsumerState<PaymentSuccessLayout> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the widget is fully mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(paymentSuccessDataProvider.notifier)
          .refreshPayment(checkoutReference: widget.checkoutReference, bufeId: widget.bufeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var payment = ref.watch(paymentSuccessDataProvider).payment;

    var state = payment?.status;
    return Stack(
      children: [
        state == null
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 60.sp,
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Expanded(child: TextField()),
                          ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: TextField()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListSeparator(padding: 8.sp, height: 1.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
                            child: TextButton(onPressed: () => context.pop(state), child: Text("ok".i18n())),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getPaymentText(state),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state == PaymentStatus.PAID
                                  ? 'payment_successful'.i18n()
                                  : state == PaymentStatus.FAILED
                                      ? 'payment_error'.i18n()
                                      : 'payment_canceled'.i18n(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                state == PaymentStatus.PAID
                                    ? 'payment_successful_text'.i18n(["", payment!.amount.toString()])
                                    : state == PaymentStatus.FAILED
                                        ? 'payment_error_text'.i18n()
                                        : 'payment_canceled_text'.i18n(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListSeparator(padding: 8.sp, height: 1.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
                          child: TextButton(onPressed: () => context.pop(state), child: Text("ok".i18n())),
                        ),
                      ),
                      // if (state == PaymentStatus.FAILED)
                      //   Expanded(
                      //     child: Padding(
                      //       padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
                      //       child:
                      //           TextButton(onPressed: () => context.pop(PaymentStatus.PENDING), child: Text("retry".i18n())),
                      //     ),
                      //   )
                    ],
                  )
                ],
              ),
        ref.watch(paymentSuccessDataProvider).modelState == ModelState.processing
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox()
      ],
    );
  }

  Widget getPaymentText(PaymentStatus status) {
    var textColor = switch (status) {
      PaymentStatus.FAILED => Colors.red,
      PaymentStatus.PENDING => Colors.orange,
      PaymentStatus.PAID => Colors.green,
      PaymentStatus.EXPIRED => Colors.grey
    };

    var bgColor = switch (status) {
      PaymentStatus.FAILED => AppColors.redRowBgColor,
      PaymentStatus.PENDING => AppColors.yellowRowBgColor,
      PaymentStatus.PAID => AppColors.greenRowBgColor,
      PaymentStatus.EXPIRED => AppColors.gray100
    };

    var iconColor = switch (status) {
      PaymentStatus.FAILED => Colors.red,
      PaymentStatus.PENDING => Colors.grey,
      PaymentStatus.PAID => Colors.green,
      PaymentStatus.EXPIRED => Colors.red
    };

    var icon = switch (status) {
      PaymentStatus.FAILED => Icons.cancel_outlined,
      PaymentStatus.PENDING => Icons.pending_outlined,
      PaymentStatus.PAID => Icons.done_rounded,
      PaymentStatus.EXPIRED => Icons.cancel
    };

    var text = switch (status) {
      PaymentStatus.FAILED => "payment_status_failed",
      PaymentStatus.PENDING => "payment_status_pending",
      PaymentStatus.PAID => "payment_status_paid",
      PaymentStatus.EXPIRED => "payment_status_expired"
    };

    return Icon(
      icon,
      color: iconColor,
      size: 60.sp,
    );
  }
}
