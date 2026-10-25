import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/payments/checkout_launcher.dart';

/// "Check payment" under the pay button while a checkout is open ([CheckoutLauncher.pendingRoute]): for people who
/// closed the payment page themselves (iOS doesn't tell the app), it opens the result page, which asks SumUp.
class PendingPaymentButton extends StatelessWidget {
  const PendingPaymentButton({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String?>(
    valueListenable: CheckoutLauncher.pendingRoute,
    builder: (context, route, _) => route == null
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.only(top: 8.sp),
            child: Center(
              child: TextButton.icon(
                onPressed: CheckoutLauncher.showPending,
                icon: const Icon(Icons.refresh),
                label: Text("payment_check".i18n()),
              ),
            ),
          ),
  );
}
