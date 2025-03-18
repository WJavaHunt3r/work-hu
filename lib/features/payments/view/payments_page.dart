import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/payments/view/payments_layout.dart';

class PaymentsPage extends BasePage {
  const PaymentsPage({super.key, this.donationId, this.userId, super.title = "payments"});

  final num? donationId;
  final num? userId;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return const PaymentsLayout();
  }
}
