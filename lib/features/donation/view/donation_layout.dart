import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_state.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/app/widgets/success_alert_dialog.dart';
import 'package:work_hu/features/donation/providers/donation_provider.dart';
import 'package:work_hu/features/donation/widgets/number_pin.dart';

class DonationLayout extends ConsumerWidget {
  const DonationLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var enabled = ref.watch(donationDataProvider).amount > 0;
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      // readOnly: ref.watch(donationDataProvider).id != null,
                      controller: ref.watch(donationDataProvider.notifier).amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 40.sp, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleMedium?.color),
                      decoration: InputDecoration(
                          suffixText: "Ft",
                          suffixStyle: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                          hintText: "0",
                          filled: false,
                          border: const OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NumberPin(enabled: true, showBorder: true, child: pinText("1"), onTap: () => addNumber("1", ref)),
                        NumberPin(enabled: true, showBorder: true, child: pinText("2"), onTap: () => addNumber("2", ref)),
                        NumberPin(enabled: true, showBorder: true, child: pinText("3  "), onTap: () => addNumber("3", ref))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NumberPin(enabled: true, showBorder: true, child: pinText("4"), onTap: () => addNumber("4", ref)),
                        NumberPin(enabled: true, showBorder: true, child: pinText("5"), onTap: () => addNumber("5", ref)),
                        NumberPin(enabled: true, showBorder: true, child: pinText("6"), onTap: () => addNumber("6", ref))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NumberPin(enabled: true, showBorder: true, child: pinText("7"), onTap: () => addNumber("7", ref)),
                        NumberPin(enabled: true, showBorder: true, child: pinText("8"), onTap: () => addNumber("8", ref)),
                        NumberPin(enabled: true, showBorder: true, child: pinText("9"), onTap: () => addNumber("9", ref))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NumberPin(
                            enabled: enabled,
                            showBorder: false,
                            child: pinText(
                              "00",
                              color: enabled ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey,
                            ),
                            onTap: () => addNumber("00", ref)),
                        NumberPin(
                            enabled: enabled,
                            showBorder: true,
                            child: pinText("0", color: enabled ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey),
                            onTap: () => addNumber("0", ref)),
                        NumberPin(
                            enabled: enabled,
                            showBorder: false,
                            child: Icon(
                              Icons.backspace,
                              color: enabled ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey,
                            ),
                            onTap: () => removeNumber(ref))
                      ],
                    )
                  ],
                )),
            ref.watch(donationDataProvider).id == null
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
                          child: TextButton(
                            onPressed: ref.watch(donationDataProvider).amount > 0
                                ? () => ref
                                    .watch(donationDataProvider.notifier)
                                    .createCheckout(UniqueKey().toString(), "Ungdoms stevne 2025")
                                : null,
                            child: Text("donate_button".i18n()),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
                          child: TextButton(
                              onPressed: () {
                                context.push("/payment/${ref.watch(donationDataProvider).id}").then((value) {
                                  value != null && context.mounted
                                      ? value == PaymentState.success
                                          ? ref.watch(donationDataProvider.notifier).savePayment()
                                          : null
                                      : showDialog(
                                          context: context, builder: (context) => const ErrorAlertDialog(title: "Error"));
                                });
                              },
                              child: Text(
                                "donate_proceed".i18n([ref.watch(donationDataProvider).amount.toString()]),
                                style: const TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  )
          ],
        ),
        ref.watch(donationDataProvider).modelState == ModelState.processing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox()
      ],
    );
  }

  void addNumber(String number, WidgetRef ref) {
    ref.watch(donationDataProvider.notifier).addNumber(number);
  }

  void removeNumber(WidgetRef ref) {
    ref.watch(donationDataProvider.notifier).removeLastNumber();
  }

  Widget pinText(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(fontSize: 24.sp, color: color),
      textAlign: TextAlign.center,
    );
  }
}
