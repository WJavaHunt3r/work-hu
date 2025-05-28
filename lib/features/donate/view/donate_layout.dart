import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/widgets/number_pin_layout.dart';
import 'package:work_hu/features/donate/providers/donate_provider.dart';

import '../data/state/donate_state.dart' show DonateState;

class DonateLayout extends ConsumerStatefulWidget {
  const DonateLayout({super.key, required this.id});

  final num id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DonateState();
  }
}

class _DonateState extends ConsumerState<DonateLayout> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the widget is fully mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(donateDataProvider.notifier).getDonation(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    DonateState state = ref.watch(donateDataProvider);
    return Stack(
      children: [
        NumberPinLayout(
          path: "/home/donate/${widget.id}",
          checkoutId: state.base64,
          amount: state.amount,
          amountController: ref.watch(donateDataProvider.notifier).amountController,
          addNumber: (text) => ref.watch(donateDataProvider.notifier).addNumber(text),
          createCheckout: () => ref.watch(donateDataProvider.notifier).createCheckout(),
          hostedUrl: state.hosted_url,
          onRemoveNumber: () => ref.watch(donateDataProvider.notifier).removeLastNumber(),
        ),
        ref.watch(donateDataProvider).modelState == ModelState.processing
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : const SizedBox()
      ],
    );
  }

  void deleteCheckout(PaymentStatus status) {
    ref.read(donateDataProvider.notifier).deleteCheckout(status);
  }

  void addNumber(String number, WidgetRef ref) {
    ref.watch(donateDataProvider.notifier).addNumber(number);
  }

  void removeNumber(WidgetRef ref) {
    ref.watch(donateDataProvider.notifier).removeLastNumber();
  }

  Widget pinText(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(fontSize: 24.sp, color: color),
      textAlign: TextAlign.center,
    );
  }
}
