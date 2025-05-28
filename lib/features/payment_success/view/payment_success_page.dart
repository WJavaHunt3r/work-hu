import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/payment_success/view/payment_success_layout.dart';
import 'package:work_hu/features/payments/view/payments_layout.dart';

class PaymentSuccessPage extends BasePage {
  const PaymentSuccessPage({super.key,this.checkoutReference, super.title = "payment_success", this.bufeId});

  final String? checkoutReference;
  final num? bufeId;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return PaymentSuccessLayout(checkoutReference: checkoutReference, bufeId: bufeId);
  }
}
