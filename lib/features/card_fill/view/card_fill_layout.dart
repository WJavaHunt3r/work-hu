import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/widgets/number_pin_layout.dart';

import 'package:work_hu/features/card_fill/providers/card_fill_provider.dart';

import '../data/state/card_fill_state.dart' show CardFillState;

class CardFillLayout extends ConsumerStatefulWidget {
  const CardFillLayout({super.key, required this.id});

  final num id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CardFillState();
  }
}

class _CardFillState extends ConsumerState<CardFillLayout> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the widget is fully mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cardFillDataProvider.notifier).setBufeId(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    CardFillState state = ref.watch(cardFillDataProvider);
    return Stack(
      children: [
        NumberPinLayout(
          buttonText: "card_fill_button",
            path: "profile/bufe/${widget.id}/cardFill",
            checkoutId: state.base64,
            amount: state.amount,
            amountController: ref.watch(cardFillDataProvider.notifier).amountController,
            addNumber: (text) => ref.watch(cardFillDataProvider.notifier).addNumber(text),
            createCheckout: () => ref.watch(cardFillDataProvider.notifier).createCheckout(),
            afterPaymentOccurred: (dynamic value) {
              if (value != null && context.mounted) {
                value == PaymentStatus.PAID
                    ? ref.read(cardFillDataProvider.notifier).savePayment()
                    : deleteCheckout(PaymentStatus.EXPIRED);
              } else {
                deleteCheckout(PaymentStatus.FAILED);
              }
            },
            onRemoveNumber: () => ref.watch(cardFillDataProvider.notifier).removeLastNumber()),
        ref.watch(cardFillDataProvider).modelState == ModelState.processing
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : const SizedBox()
      ],
    );
  }

  void deleteCheckout(PaymentStatus status) {
    ref.read(cardFillDataProvider.notifier).deleteCheckout(status);
  }

  void addNumber(String number, WidgetRef ref) {
    ref.watch(cardFillDataProvider.notifier).addNumber(number);
  }

  void removeNumber(WidgetRef ref) {
    ref.watch(cardFillDataProvider.notifier).removeLastNumber();
  }

  Widget pinText(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(fontSize: 24.sp, color: color),
      textAlign: TextAlign.center,
    );
  }
}
