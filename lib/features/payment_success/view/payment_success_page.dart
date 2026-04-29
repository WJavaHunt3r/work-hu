import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/features/payment_success/view/payment_success_layout.dart';
import 'package:work_hu/features/payments/view/payments_layout.dart';

class PaymentSuccessPage extends LegacyBasePage {
  const PaymentSuccessPage({super.key,this.checkoutReference, super.title = "payment_success",});

  final String? checkoutReference;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return PaymentSuccessLayout(checkoutReference: checkoutReference);
  }
}
